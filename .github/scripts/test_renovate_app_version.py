import importlib.util
import json
import os
import pathlib
import subprocess
import tempfile
import unittest


SCRIPT_PATH = pathlib.Path(__file__).with_name("renovate_app_version.py")
REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]


def load_module():
    spec = importlib.util.spec_from_file_location("renovate_app_version", SCRIPT_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"unable to load {SCRIPT_PATH}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def compose(images):
    return {"services": {name: {"image": image} for name, image in images.items()}}


class RenovateAppVersionTests(unittest.TestCase):
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
        config = json.loads((REPO_ROOT / "renovate.json").read_text(encoding="utf-8"))
        matching = [
            rule
            for rule in config.get("packageRules", [])
            if "apps/flux-panel/**/docker-compose.yml" in rule.get("matchFileNames", [])
        ]

        self.assertTrue(matching)
        self.assertTrue(any(rule.get("enabled") is False for rule in matching))

    def test_self_hosted_renovate_targets_this_repository(self):
        workflow = (REPO_ROOT / ".github" / "workflows" / "renovate.yml").read_text(encoding="utf-8")

        self.assertIn("RENOVATE_REPOSITORIES: ${{ github.repository }}", workflow)

    def test_self_hosted_renovate_uses_semantic_entrypoint(self):
        workflow = (REPO_ROOT / ".github" / "workflows" / "renovate.yml").read_text(encoding="utf-8")

        self.assertIn("docker-cmd-file: .github/scripts/renovate-entrypoint.sh", workflow)

    def test_self_hosted_renovate_requires_docker_hub_credentials(self):
        workflow = (REPO_ROOT / ".github" / "workflows" / "renovate.yml").read_text(encoding="utf-8")

        self.assertIn("configurationFile: .github/renovate-global.js", workflow)
        self.assertIn("RENOVATE_DOCKERHUB_USERNAME: ${{ secrets.DOCKERHUB_USERNAME }}", workflow)
        self.assertIn("RENOVATE_DOCKERHUB_TOKEN: ${{ secrets.DOCKERHUB_TOKEN }}", workflow)
        self.assertIn("name: Check Docker Hub credentials", workflow)
        self.assertIn("Configure DOCKERHUB_USERNAME and DOCKERHUB_TOKEN repository secrets", workflow)

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
        expression = f"const c=require({json.dumps(str(config))}); console.log(JSON.stringify(c.hostRules[0]))"

        result = subprocess.run(["node", "-e", expression], text=True, capture_output=True, env=env, check=False)
        host_rule = json.loads(result.stdout)

        self.assertEqual(0, result.returncode)
        self.assertEqual("docker", host_rule["hostType"])
        self.assertEqual("docker.io", host_rule["matchHost"])
        self.assertEqual("renovate-user", host_rule["username"])
        self.assertEqual("test-token", host_rule["password"])

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
