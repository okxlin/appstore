#!/usr/bin/env python3
import importlib.util
import unittest
from pathlib import Path


SCRIPT_PATH = Path(__file__).with_name("renovate_sidecar_guard.py")
SPEC = importlib.util.spec_from_file_location("renovate_sidecar_guard", SCRIPT_PATH)
GUARD = importlib.util.module_from_spec(SPEC)
assert SPEC and SPEC.loader
SPEC.loader.exec_module(GUARD)


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


if __name__ == "__main__":
    unittest.main()
