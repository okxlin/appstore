import importlib.util
import json
import os
import pathlib
import subprocess
import tempfile
import unittest


SCRIPT_PATH = pathlib.Path(__file__).with_name("renovate_app_version.py")
RETRY_SCRIPT_PATH = pathlib.Path(__file__).with_name("renovate_retry_gate.py")
REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]
DOCKER_CONFIG = REPO_ROOT / ".github" / "renovate-docker.json"
HOSTED_CONFIG = REPO_ROOT / "renovate.json"


def load_module():
    spec = importlib.util.spec_from_file_location("renovate_app_version", SCRIPT_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"unable to load {SCRIPT_PATH}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def load_retry_module():
    spec = importlib.util.spec_from_file_location("renovate_retry_gate", RETRY_SCRIPT_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"unable to load {RETRY_SCRIPT_PATH}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def compose(images):
    return {"services": {name: {"image": image} for name, image in images.items()}}


class RenovateAppVersionTests(unittest.TestCase):
    def test_mend_is_primary_for_actions_and_compose_updates(self):
        config = json.loads(HOSTED_CONFIG.read_text(encoding="utf-8"))

        self.assertEqual({"github-actions", "docker-compose"}, set(config["enabledManagers"]))
        self.assertIn(
            "github>okxlin/appstore//.github/renovate-docker.json",
            config["extends"],
        )

    def test_self_hosted_compose_scan_is_semimonthly_read_only_audit(self):
        workflow = (REPO_ROOT / ".github" / "workflows" / "renovate.yml").read_text(
            encoding="utf-8"
        )

        self.assertIn('cron: "23 3 1,15 * *"', workflow)
        self.assertIn("RENOVATE_DRY_RUN: lookup", workflow)
        self.assertIn("token: ${{ github.token }}", workflow)
        self.assertNotIn("token: ${{ secrets.GITHUBTOKEN }}", workflow)

    def test_retry_gate_retries_only_mature_docker_hub_429_failures(self):
        module = load_retry_module()
        now = module.parse_timestamp("2026-07-12T06:00:00Z")
        runs = [
            {
                "databaseId": 10,
                "status": "completed",
                "conclusion": "failure",
                "createdAt": "2026-07-12T04:50:00Z",
                "updatedAt": "2026-07-12T05:00:00Z",
            }
        ]

        decision = module.evaluate_retry(runs, "HTTP 429 Too Many Requests from index.docker.io", now)

        self.assertEqual("retry", decision["decision"])

    def test_retry_gate_rejects_non_rate_limit_failures_and_retry_storms(self):
        module = load_retry_module()
        now = module.parse_timestamp("2026-07-12T06:00:00Z")
        base_run = {
            "status": "completed",
            "conclusion": "failure",
            "createdAt": "2026-07-12T04:50:00Z",
            "updatedAt": "2026-07-12T05:00:00Z",
        }

        non_429 = module.evaluate_retry(
            [{"databaseId": 10, **base_run}], "ordinary configuration failure", now
        )
        too_soon = module.evaluate_retry(
            [{"databaseId": 10, **base_run, "updatedAt": "2026-07-12T05:30:00Z"}],
            "Docker Hub status code 429",
            now,
        )
        too_many = module.evaluate_retry(
            [
                {"databaseId": index, **base_run, "createdAt": f"2026-07-12T0{index}:00:00Z"}
                for index in range(1, 7)
            ],
            "registry-1.docker.io status code 429",
            now,
        )

        self.assertEqual("skip", non_429["decision"])
        self.assertEqual("wait", too_soon["decision"])
        self.assertEqual("limit", too_many["decision"])

    def test_retry_workflow_and_sidecar_branch_cleanup_are_guarded(self):
        retry_workflow = (
            REPO_ROOT / ".github" / "workflows" / "renovate-rate-limit-retry.yml"
        ).read_text(encoding="utf-8")
        sidecar_workflow = (
            REPO_ROOT / ".github" / "workflows" / "renovate-sidecar-guard.yml"
        ).read_text(encoding="utf-8")

        self.assertIn("17 * * * *", retry_workflow)
        self.assertIn("actions: write", retry_workflow)
        self.assertIn("renovate_retry_gate.py", retry_workflow)
        self.assertIn("automatic retry after Docker Hub 429", retry_workflow)
        self.assertIn('[[ "$head_repo" == "$REPO" ]]', sidecar_workflow)
        self.assertIn('selfhosted-renovate/*|renovate/*', sidecar_workflow)
        self.assertIn("git/refs/heads/$head_ref", sidecar_workflow)
    def test_image_tag_strips_digest_from_tagged_image(self):
        module = load_module()

        self.assertEqual(
            "1.2.3",
            module.image_tag("registry.example.com:5000/demo/app:v1.2.3@sha256:deadbeef"),
        )

    def test_image_tag_rejects_digest_only_image(self):
        module = load_module()

        self.assertEqual("", module.image_tag("example/demo@sha256:deadbeef"))

    def test_single_service_uses_the_changed_service_tag(self):
        module = load_module()

        selection = module.select_target_version(
            "demo",
            compose({"app": "example/demo:1.0.0"}),
            compose({"app": "example/demo:1.0.1"}),
            {},
        )

        self.assertEqual("1.0.1", selection.version)
        self.assertEqual(["app"], selection.changed_services)

    def test_single_service_uses_tag_without_digest_for_directory_version(self):
        module = load_module()

        selection = module.select_target_version(
            "demo",
            compose({"app": "example/demo:1.0.0@sha256:old"}),
            compose({"app": "example/demo:1.0.1@sha256:new"}),
            {},
        )

        self.assertEqual("1.0.1", selection.version)

    def test_multi_service_sidecar_only_change_does_not_rename(self):
        module = load_module()

        selection = module.select_target_version(
            "demo",
            compose({"app": "example/demo:1.0.0", "db": "postgres:17.5"}),
            compose({"app": "example/demo:1.0.0", "db": "postgres:17.6"}),
            {"demo": ["app"]},
        )

        self.assertEqual("", selection.version)
        self.assertEqual("multi-service compose changed only auxiliary services", selection.reason)

    def test_multi_service_without_primary_mapping_does_not_use_first_service(self):
        module = load_module()

        selection = module.select_target_version(
            "flux-panel",
            compose(
                {
                    "mysql": "mysql:5.7",
                    "backend": "bqlpfy/springboot-backend:1.4.3",
                    "frontend": "bqlpfy/vite-frontend:1.4.3",
                }
            ),
            compose(
                {
                    "mysql": "mysql:5.7",
                    "backend": "bqlpfy/springboot-backend:1.4.3",
                    "frontend": "bqlpfy/vite-frontend:v3.1.2",
                }
            ),
            {},
        )

        self.assertEqual("", selection.version)
        self.assertEqual("multi-service compose has no primary service mapping", selection.reason)

    def test_multi_service_primary_change_uses_primary_tag(self):
        module = load_module()

        selection = module.select_target_version(
            "rocketchat",
            compose({"rocketchat": "rocket.chat:8.6.0", "mongodb": "mongodb:8.2"}),
            compose({"rocketchat": "rocket.chat:8.6.1", "mongodb": "mongodb:8.2"}),
            {"rocketchat": ["rocketchat"]},
        )

        self.assertEqual("8.6.1", selection.version)
        self.assertEqual("rocketchat", selection.service)

    def test_changed_primary_services_must_have_one_coordinated_tag(self):
        module = load_module()

        with self.assertRaisesRegex(ValueError, "different target tags"):
            module.select_target_version(
                "demo",
                compose({"api": "example/api:1.0.0", "web": "example/web:1.0.0"}),
                compose({"api": "example/api:2.0.0", "web": "example/web:3.0.0"}),
                {"demo": ["api", "web"]},
            )

    def test_flux_panel_is_pinned_while_upstream_is_paused(self):
        config = json.loads(DOCKER_CONFIG.read_text(encoding="utf-8"))
        matching = [
            rule
            for rule in config.get("packageRules", [])
            if "apps/flux-panel/**/docker-compose.yml" in rule.get("matchFileNames", [])
        ]

        self.assertTrue(matching)
        self.assertTrue(any(rule.get("enabled") is False for rule in matching))

    def test_multi_service_application_images_are_grouped(self):
        config = json.loads(DOCKER_CONFIG.read_text(encoding="utf-8"))
        groups = {rule.get("groupName"): set(rule.get("matchPackageNames", [])) for rule in config.get("packageRules", []) if rule.get("groupName")}

        self.assertEqual(
            {
                "docker.elastic.co/elasticsearch/elasticsearch",
                "docker.elastic.co/kibana/kibana",
            },
            groups["Kibana application images"],
        )
        self.assertEqual(
            {
                "ghcr.io/clearflask/clearflask-connect",
                "ghcr.io/clearflask/clearflask-server",
            },
            groups["ClearFlask application images"],
        )

    def test_historical_tracks_and_known_sidecars_are_not_renovated(self):
        config = json.loads(DOCKER_CONFIG.read_text(encoding="utf-8"))
        disabled = [rule for rule in config.get("packageRules", []) if rule.get("enabled") is False]

        disabled_paths = {path for rule in disabled for path in rule.get("matchFileNames", [])}
        self.assertTrue(
            {
                "apps/geekbench/4/**",
                "apps/geekbench/5/**",
                "apps/headscale/0.23.0-alpha3/**",
                "apps/headscale/0.26.1/**",
                "apps/mysql/5.5.62/**",
            }.issubset(disabled_paths)
        )
        self.assertTrue(
            any(
                "apps/*-linuxserver/**/docker-compose.yml" in rule.get("matchFileNames", [])
                and {"mariadb", "mongo"}.issubset(set(rule.get("matchPackageNames", [])))
                for rule in disabled
            )
        )
        self.assertTrue(
            any(
                "apps/traccar/**/docker-compose.yml" in rule.get("matchFileNames", [])
                and "mysql" in rule.get("matchPackageNames", [])
                for rule in disabled
            )
        )

    def test_self_hosted_renovate_targets_this_repository(self):
        workflow = (REPO_ROOT / ".github" / "workflows" / "renovate.yml").read_text(encoding="utf-8")

        self.assertIn("RENOVATE_REPOSITORIES: ${{ github.repository }}", workflow)

    def test_compose_audit_is_semimonthly_or_manual_only(self):
        workflow = (REPO_ROOT / ".github" / "workflows" / "renovate.yml").read_text(encoding="utf-8")

        self.assertNotIn("  push:\n", workflow)
        self.assertIn('    - cron: "23 3 1,15 * *"', workflow)
        self.assertIn("  workflow_dispatch:", workflow)

    def test_compose_audit_does_not_overlap(self):
        workflow = (REPO_ROOT / ".github" / "workflows" / "renovate.yml").read_text(encoding="utf-8")

        self.assertIn("concurrency:\n  group: renovate-compose-audit\n  cancel-in-progress: true", workflow)
        self.assertIn("permissions:\n  contents: read", workflow)
        self.assertIn("timeout-minutes: 90", workflow)

    def test_self_hosted_renovate_uses_semantic_entrypoint(self):
        workflow = (REPO_ROOT / ".github" / "workflows" / "renovate.yml").read_text(encoding="utf-8")

        self.assertIn("docker-cmd-file: .github/scripts/renovate-entrypoint.sh", workflow)

    def test_self_hosted_renovate_requires_docker_hub_credentials(self):
        workflow = (REPO_ROOT / ".github" / "workflows" / "renovate.yml").read_text(encoding="utf-8")
        preflight = (
            REPO_ROOT / ".github" / "workflows" / "renovate-dockerhub-preflight.yml"
        ).read_text(encoding="utf-8")
        checker = (
            REPO_ROOT / ".github" / "scripts" / "check_dockerhub_credentials.mjs"
        ).read_text(encoding="utf-8")

        self.assertIn("configurationFile: .github/renovate-global.js", workflow)
        self.assertIn(
            "docker-volumes: ${{ github.workspace }}/.github/renovate-docker.json:/github-action/renovate-docker.json:ro;/tmp:/tmp",
            workflow,
        )
        self.assertIn("RENOVATE_DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}", workflow)
        self.assertIn("RENOVATE_DOCKERHUB_TOKEN: ${{ secrets.DOCKERHUB_TOKEN }}", workflow)
        self.assertIn("name: Check Docker Hub credentials", workflow)
        self.assertIn("node .github/scripts/check_dockerhub_credentials.mjs", workflow)
        self.assertIn("workflow_dispatch:", preflight)
        self.assertIn("node .github/scripts/check_dockerhub_credentials.mjs", preflight)
        self.assertIn("https://auth.docker.io/token", checker)
        self.assertIn("https://registry-1.docker.io/v2/library/alpine/manifests/latest", checker)
        self.assertNotIn("console.log(token", checker)
        self.assertNotIn("console.log(password", checker)

    def test_docker_hub_preflight_validates_auth_and_manifest_without_logging_token(self):
        checker = REPO_ROOT / ".github" / "scripts" / "check_dockerhub_credentials.mjs"
        expression = f"""
          import {{ checkDockerHubCredentials }} from {json.dumps(checker.as_uri())};
          const requests = [];
          const responses = [
            {{ ok: true, status: 200, json: async () => ({{ token: 'bearer-secret' }}) }},
            {{
              ok: true,
              status: 200,
              headers: new Headers({{
                'ratelimit-limit': '200;w=21600',
                'ratelimit-remaining': '199;w=21600',
              }}),
            }},
          ];
          const result = await checkDockerHubCredentials({{
            username: 'test-user',
            password: 'test-password',
            fetchImpl: async (url, options) => {{
              requests.push({{ url, authorization: options.headers.authorization }});
              return responses.shift();
            }},
          }});
          console.log(JSON.stringify({{ result, requests }}));
        """

        result = subprocess.run(
            ["node", "--input-type=module", "-e", expression],
            text=True,
            capture_output=True,
            check=False,
        )
        payload = json.loads(result.stdout)

        self.assertEqual(0, result.returncode)
        self.assertEqual("199;w=21600", payload["result"]["remaining"])
        self.assertTrue(payload["requests"][0]["authorization"].startswith("Basic "))
        self.assertEqual("Bearer bearer-secret", payload["requests"][1]["authorization"])

    def test_self_hosted_renovate_uses_a_pinned_persistent_cache(self):
        workflow = (REPO_ROOT / ".github" / "workflows" / "renovate.yml").read_text(
            encoding="utf-8"
        )

        self.assertIn(
            "uses: actions/cache/restore@55cc8345863c7cc4c66a329aec7e433d2d1c52a9 # v6.1.0",
            workflow,
        )
        self.assertIn(
            "uses: actions/cache/save@55cc8345863c7cc4c66a329aec7e433d2d1c52a9 # v6.1.0",
            workflow,
        )
        self.assertIn("path: /tmp/renovate-cache", workflow)
        self.assertIn("${{ github.run_id }}", workflow)
        self.assertIn("RENOVATE_CACHE_DIR: /tmp/renovate-cache", workflow)
        self.assertIn("RENOVATE_REPOSITORY_CACHE: enabled", workflow)
        self.assertIn("RENOVATE_CACHE_PRIVATE_PACKAGES: 'false'", workflow)
        self.assertIn("chmod -R a+rwX /tmp/renovate-cache", workflow)
        self.assertIn("du -sh /tmp/renovate-cache", workflow)
        self.assertIn("max_cache_bytes=536870912", workflow)
        self.assertNotIn("pull_request:\n", workflow)
        self.assertNotIn("pull_request_target:\n", workflow)

    def test_hosted_renovate_owns_updates_while_self_hosted_is_compose_only(self):
        hosted = json.loads((REPO_ROOT / "renovate.json").read_text(encoding="utf-8"))
        docker = json.loads(
            (REPO_ROOT / ".github" / "renovate-docker.json").read_text(encoding="utf-8")
        )

        self.assertEqual(["github-actions", "docker-compose"], hosted["enabledManagers"])
        self.assertEqual(["docker-compose"], docker["enabledManagers"])
        self.assertTrue(
            (REPO_ROOT / ".github" / "renovate-controller-policy.md").is_file()
        )

    def test_self_hosted_renovate_owns_a_separate_namespace(self):
        config = REPO_ROOT / ".github" / "renovate-global.js"
        env = os.environ.copy()
        env["RENOVATE_DOCKERHUB_USERNAME"] = "renovate-user"
        env["RENOVATE_DOCKERHUB_TOKEN"] = "test-token"
        expression = f"const c=require({json.dumps(str(config))}); console.log(JSON.stringify(c))"

        result = subprocess.run(
            ["node", "-e", expression], text=True, capture_output=True, env=env, check=False
        )
        parsed = json.loads(result.stdout)

        self.assertEqual(0, result.returncode)
        self.assertEqual("ignored", parsed["requireConfig"])
        self.assertEqual("selfhosted-renovate/", parsed["branchPrefix"])
        self.assertEqual(
            "Dependency Dashboard (Docker Images)", parsed["dependencyDashboardTitle"]
        )
        self.assertEqual(["docker-compose"], parsed["enabledManagers"])

    def test_global_config_fails_fast_without_docker_hub_credentials(self):
        config = REPO_ROOT / ".github" / "renovate-global.js"
        env = os.environ.copy()
        env.pop("RENOVATE_DOCKERHUB_USERNAME", None)
        env.pop("RENOVATE_DOCKERHUB_TOKEN", None)

        result = subprocess.run(["node", "-e", f"require({json.dumps(str(config))})"], text=True, capture_output=True, env=env, check=False)

        self.assertNotEqual(0, result.returncode)
        self.assertIn("DOCKERHUB_USERNAME and DOCKERHUB_TOKEN", result.stderr)

    def test_global_config_authenticates_docker_hub(self):
        config = REPO_ROOT / ".github" / "renovate-global.js"
        env = os.environ.copy()
        env["RENOVATE_DOCKERHUB_USERNAME"] = "renovate-user"
        env["RENOVATE_DOCKERHUB_TOKEN"] = "test-token"
        expression = f"const c=require({json.dumps(str(config))}); console.log(JSON.stringify(c.hostRules))"

        result = subprocess.run(["node", "-e", expression], text=True, capture_output=True, env=env, check=False)
        host_rules = json.loads(result.stdout)

        self.assertEqual(0, result.returncode)
        self.assertEqual(
            {"docker.io", "index.docker.io", "registry-1.docker.io"},
            {rule["matchHost"] for rule in host_rules},
        )
        for host_rule in host_rules:
            self.assertEqual("docker", host_rule["hostType"])
            self.assertEqual("renovate-user", host_rule["username"])
            self.assertEqual("test-token", host_rule["password"])

    def test_self_hosted_renovate_branches_are_recognized_by_workflows(self):
        workflows = REPO_ROOT / ".github" / "workflows"
        app_version = (workflows / "renovate-app-version.yml").read_text(encoding="utf-8")
        sidecar_guard = (workflows / "renovate-sidecar-guard.yml").read_text(encoding="utf-8")
        automerge = (workflows / "renovate-automerge.yml").read_text(encoding="utf-8")
        reconcile = (workflows / "renovate-automerge-reconcile.yml").read_text(encoding="utf-8")
        labeling = (workflows / "label-third-party-prs.yml").read_text(encoding="utf-8")

        self.assertIn("'selfhosted-renovate/*'", app_version)
        self.assertIn("startsWith(github.ref_name, 'selfhosted-renovate/')", app_version)
        for workflow in (sidecar_guard, automerge, labeling):
            self.assertIn("github.event.pull_request.head.repo.full_name == github.repository", workflow)
            self.assertIn(
                "startsWith(github.event.pull_request.head.ref, 'selfhosted-renovate/')",
                workflow,
            )
        self.assertIn("headRefName,headRepositoryOwner,isCrossRepository", reconcile)
        self.assertIn('.headRefName | startswith("selfhosted-renovate/")', reconcile)

    def test_semantic_entrypoint_blocks_external_host_abort(self):
        entrypoint = REPO_ROOT / ".github" / "scripts" / "renovate-entrypoint.sh"
        with tempfile.TemporaryDirectory(prefix="renovate-entrypoint-test-") as tmp:
            fake_renovate = pathlib.Path(tmp) / "renovate"
            fake_renovate.write_text(
                "#!/usr/bin/env bash\n"
                "echo 'INFO: External host error causing abort - skipping'\n"
                "echo '\"result\": \"external-host-error\"'\n",
                encoding="utf-8",
            )
            fake_renovate.chmod(0o755)
            env = os.environ.copy()
            env["PATH"] = f"{tmp}:{env['PATH']}"

            result = subprocess.run(["bash", str(entrypoint)], text=True, capture_output=True, env=env, check=False)

        self.assertNotEqual(0, result.returncode)
        self.assertIn("Renovate aborted because an external host failed", result.stderr)

    def test_semantic_entrypoint_preserves_clean_success(self):
        entrypoint = REPO_ROOT / ".github" / "scripts" / "renovate-entrypoint.sh"
        with tempfile.TemporaryDirectory(prefix="renovate-entrypoint-test-") as tmp:
            fake_renovate = pathlib.Path(tmp) / "renovate"
            fake_renovate.write_text("#!/usr/bin/env bash\necho 'Repository finished'\n", encoding="utf-8")
            fake_renovate.chmod(0o755)
            env = os.environ.copy()
            env["PATH"] = f"{tmp}:{env['PATH']}"

            result = subprocess.run(["bash", str(entrypoint)], text=True, capture_output=True, env=env, check=False)

        self.assertEqual(0, result.returncode)

    def test_semantic_entrypoint_preserves_renovate_failure(self):
        entrypoint = REPO_ROOT / ".github" / "scripts" / "renovate-entrypoint.sh"
        with tempfile.TemporaryDirectory(prefix="renovate-entrypoint-test-") as tmp:
            fake_renovate = pathlib.Path(tmp) / "renovate"
            fake_renovate.write_text("#!/usr/bin/env bash\necho 'ordinary failure'\nexit 23\n", encoding="utf-8")
            fake_renovate.chmod(0o755)
            env = os.environ.copy()
            env["PATH"] = f"{tmp}:{env['PATH']}"

            result = subprocess.run(["bash", str(entrypoint)], text=True, capture_output=True, env=env, check=False)

        self.assertEqual(23, result.returncode)


if __name__ == "__main__":
    unittest.main()
