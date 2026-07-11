import importlib.util
import json
import pathlib
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


if __name__ == "__main__":
    unittest.main()
