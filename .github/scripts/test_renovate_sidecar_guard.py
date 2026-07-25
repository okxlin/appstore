#!/usr/bin/env python3
import importlib.util
import json
import unittest
from pathlib import Path


SCRIPT_PATH = Path(__file__).with_name("renovate_sidecar_guard.py")
SPEC = importlib.util.spec_from_file_location("renovate_sidecar_guard", SCRIPT_PATH)
GUARD = importlib.util.module_from_spec(SPEC)
assert SPEC and SPEC.loader
SPEC.loader.exec_module(GUARD)

REPOSITORY_ROOT = Path(__file__).resolve().parents[2]
PRIMARY_SERVICES_PATH = REPOSITORY_ROOT / ".github" / "renovate-primary-services.json"
RENOVATE_CONFIG_PATH = REPOSITORY_ROOT / ".github" / "renovate-docker.json"


def compose(**images: str) -> dict:
    return {"services": {name: {"image": image} for name, image in images.items()}}


class ResolvePrimaryServicesTests(unittest.TestCase):
    def test_infers_app_named_service_for_multi_service_app(self) -> None:
        base = compose(cache="valkey:9.1.0", database="postgres:18", weblate="weblate:latest")
        head = compose(cache="valkey:9.1.1", database="postgres:18", weblate="weblate:latest")

        resolved = GUARD.resolve_primary_services("weblate", [], base, head)

        self.assertEqual(resolved, ["weblate"])

    def test_explicit_mapping_takes_precedence(self) -> None:
        base = compose(api="example/api:1", sample="example/sample:1")
        head = compose(api="example/api:2", sample="example/sample:1")

        resolved = GUARD.resolve_primary_services("sample", ["api"], base, head)

        self.assertEqual(resolved, ["api"])

    def test_does_not_guess_when_no_service_matches_app_key(self) -> None:
        base = compose(api="example/api:1", worker="example/worker:1")
        head = compose(api="example/api:1", worker="example/worker:2")

        resolved = GUARD.resolve_primary_services("sample", [], base, head)

        self.assertEqual(resolved, [])

    def test_does_not_infer_for_single_service_app(self) -> None:
        base = compose(valkey="valkey:9.1.0")
        head = compose(valkey="valkey:9.1.1")

        resolved = GUARD.resolve_primary_services("valkey", [], base, head)

        self.assertEqual(resolved, [])


class InferredPrimaryDecisionTests(unittest.TestCase):
    def test_closes_weblate_sidecar_only_update(self) -> None:
        base = compose(cache="valkey:9.1.0", database="postgres:18", weblate="weblate:latest")
        head = compose(cache="valkey:9.1.1", database="postgres:18", weblate="weblate:latest")
        primary = GUARD.resolve_primary_services("weblate", [], base, head)

        decision = GUARD.compare_compose("weblate", "apps/weblate/latest/docker-compose.yml", base, head, primary)

        self.assertEqual(decision.outcome, "close")
        self.assertEqual(decision.changed_services, ["cache"])

    def test_allows_inferred_primary_update(self) -> None:
        base = compose(cache="valkey:9.1.0", database="postgres:18", weblate="weblate:1")
        head = compose(cache="valkey:9.1.1", database="postgres:18", weblate="weblate:2")
        primary = GUARD.resolve_primary_services("weblate", [], base, head)

        decision = GUARD.compare_compose("weblate", "apps/weblate/latest/docker-compose.yml", base, head, primary)

        self.assertEqual(decision.outcome, "allow")

    def test_allows_independent_single_service_app(self) -> None:
        base = compose(server="valkey:9.1.0")
        head = compose(server="valkey:9.1.1")

        decision = GUARD.compare_compose("valkey", "apps/valkey/latest/docker-compose.yml", base, head, [])

        self.assertEqual(decision.outcome, "allow")
        self.assertEqual(decision.detail, "single-service compose")


class RepositoryPolicyTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.primary_services = json.loads(PRIMARY_SERVICES_PATH.read_text(encoding="utf-8"))
        cls.renovate_config = json.loads(RENOVATE_CONFIG_PATH.read_text(encoding="utf-8"))

    def disabled_rule_exists(self, file_pattern: str, package_name: str | None = None) -> bool:
        for rule in self.renovate_config["packageRules"]:
            if rule.get("enabled") is not False:
                continue
            if file_pattern not in rule.get("matchFileNames", []):
                continue
            if package_name is None or package_name in rule.get("matchPackageNames", []):
                return True
        return False

    def test_dify_plugin_daemon_is_not_a_primary_service(self) -> None:
        self.assertNotIn("plugin_daemon", self.primary_services["dify"])
        self.assertTrue(
            self.disabled_rule_exists(
                "apps/dify/**/docker-compose.yml",
                "langgenius/dify-plugin-daemon",
            )
        )

        base = compose(api="langgenius/dify-api:1.16.0", plugin_daemon="langgenius/dify-plugin-daemon:0.6.3-local")
        head = compose(api="langgenius/dify-api:1.16.0", plugin_daemon="langgenius/dify-plugin-daemon:0.6.5-local")
        decision = GUARD.compare_compose(
            "dify",
            "apps/dify/1.16.0/docker-compose.yml",
            base,
            head,
            self.primary_services["dify"],
        )

        self.assertEqual(decision.outcome, "close")

    def test_safeline_components_are_grouped_behind_management_service(self) -> None:
        self.assertEqual(self.primary_services["safeline"], ["safeline-mgt"])
        expected_images = {
            "chaitin/safeline-chaos",
            "chaitin/safeline-detector",
            "chaitin/safeline-fvm",
            "chaitin/safeline-luigi",
            "chaitin/safeline-mgt",
            "chaitin/safeline-tengine",
        }
        grouped_rules = [
            rule
            for rule in self.renovate_config["packageRules"]
            if rule.get("groupName") == "SafeLine application images"
        ]

        self.assertEqual(len(grouped_rules), 1)
        self.assertEqual(set(grouped_rules[0]["matchPackageNames"]), expected_images)
        self.assertIn("apps/safeline/**/docker-compose.yml", grouped_rules[0]["matchFileNames"])

    def test_blocked_historical_tracks_are_immutable(self) -> None:
        expected_patterns = {
            "apps/headscale/0.27.1/**",
            "apps/headscale/0.28.0/**",
            "apps/immich/1.122.3/**",
            "apps/safeline/7.3.1/**",
            "apps/safeline/newnet-7.3.1/**",
        }

        for pattern in expected_patterns:
            with self.subTest(pattern=pattern):
                self.assertTrue(self.disabled_rule_exists(pattern))

    def test_uuwaf_database_is_not_updated_independently(self) -> None:
        self.assertEqual(self.primary_services["uuwaf"], ["uuwaf"])
        self.assertTrue(
            self.disabled_rule_exists(
                "apps/uuwaf/**/docker-compose.yml",
                "percona/percona-server",
            )
        )

        base = compose(uuwaf="uusec/nanqiang:v6.8.0", wafdb="percona/percona-server:5.7.44")
        head = compose(uuwaf="uusec/nanqiang:v6.8.0", wafdb="percona/percona-server:8.4.2")
        decision = GUARD.compare_compose(
            "uuwaf",
            "apps/uuwaf/6.8.0/docker-compose.yml",
            base,
            head,
            self.primary_services["uuwaf"],
        )

        self.assertEqual(decision.outcome, "close")

    def test_langflow_updates_require_manual_compatibility_review(self) -> None:
        self.assertTrue(
            self.disabled_rule_exists(
                "apps/langflow/**/docker-compose.yml",
                "langflowai/langflow",
            )
        )


if __name__ == "__main__":
    unittest.main()
