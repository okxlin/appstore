import importlib.util
import json
import unittest
from datetime import datetime, timedelta, timezone
from pathlib import Path
import subprocess
import sys
import tempfile


SCRIPT_PATH = Path(__file__).with_name("prune_deepseek_harness_versions.py")
SPEC = importlib.util.spec_from_file_location("dsh_retention", SCRIPT_PATH)
if SPEC is None or SPEC.loader is None:
    raise RuntimeError(f"unable to load {SCRIPT_PATH}")
RETENTION = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(RETENTION)


class DeepSeekHarnessRetentionTests(unittest.TestCase):
    def test_new_version_resets_coexistence_window(self):
        now = datetime(2026, 11, 6, 12, tzinfo=timezone.utc)
        versions = [
            "0.2.0-rc.2-workstation",
            "0.2.1-rc.2-workstation",
            "0.2.1-rc.3-workstation",
            "0.2.2-alpha.2-workstation",
            "0.2.2-rc.1-workstation",
        ]
        old = (now - timedelta(days=30)).isoformat()
        timestamps = {name: old for name in versions[:-1]}
        timestamps[versions[-1]] = now.isoformat()

        self.assertEqual([], RETENTION.prunable_versions(versions, timestamps, now))
        self.assertEqual(
            versions[:2],
            RETENTION.prunable_versions(versions, timestamps, now + timedelta(days=7)),
        )

    def test_first_observation_starts_grace_period(self):
        now = datetime(2026, 11, 6, 12, tzinfo=timezone.utc)
        existing = {"0.2.0-rc.2-workstation": (now - timedelta(days=90)).isoformat()}

        timestamps = RETENTION.initialized_timestamps(
            ["0.2.0-rc.2-workstation", "0.2.2-rc.1-workstation"],
            existing,
            now,
        )

        self.assertEqual(now.isoformat(timespec="seconds"), timestamps["0.2.2-rc.1-workstation"])

    def test_prerelease_order_matches_release_channels(self):
        names = [
            "0.2.2-rc.1-workstation",
            "0.2.2-alpha.2-workstation",
            "0.2.2-workstation",
            "0.2.2-beta.1-workstation",
        ]
        self.assertEqual(
            [
                "0.2.2-alpha.2-workstation",
                "0.2.2-beta.1-workstation",
                "0.2.2-rc.1-workstation",
                "0.2.2-workstation",
            ],
            sorted(names, key=RETENTION.version_key),
        )

    def test_script_starts_grace_then_prunes_only_oldest_fixed_versions(self):
        names = [
            "0.2.0-rc.2-workstation",
            "0.2.1-rc.2-workstation",
            "0.2.1-rc.3-workstation",
            "0.2.2-alpha.2-workstation",
            "0.2.2-rc.1-workstation",
        ]
        with tempfile.TemporaryDirectory(prefix="dsh-retention-integration-") as tmp:
            repo = Path(tmp)
            app_root = repo / RETENTION.APP_ROOT
            for name in names:
                version_dir = app_root / name
                version_dir.mkdir(parents=True)
                (version_dir / "docker-compose.yml").write_text(
                    f"services:\n  app:\n    image: example/app:{name}\n", encoding="utf-8"
                )
            script = repo / ".github/scripts/prune_deepseek_harness_versions.py"
            script.parent.mkdir(parents=True)
            script.write_text(SCRIPT_PATH.read_text(encoding="utf-8"), encoding="utf-8")

            for command in (
                ["git", "init", "-q"],
                ["git", "config", "user.name", "Retention Test"],
                ["git", "config", "user.email", "retention@example.com"],
                ["git", "add", "apps", ".github/scripts/prune_deepseek_harness_versions.py"],
                ["git", "commit", "-qm", "seed test versions"],
            ):
                subprocess.run(command, cwd=repo, check=True)

            first = subprocess.run(
                [sys.executable, str(script)], cwd=repo, text=True, capture_output=True, check=False
            )
            self.assertEqual(0, first.returncode, first.stderr)
            self.assertTrue(all((app_root / name).is_dir() for name in names))

            registry = repo / RETENTION.RETENTION_FILE
            payload = json.loads(registry.read_text(encoding="utf-8"))
            expired = (datetime.now(timezone.utc) - RETENTION.GRACE_PERIOD - timedelta(hours=1)).isoformat()
            payload["versions"] = {name: expired for name in names}
            registry.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
            subprocess.run(["git", "add", registry.relative_to(repo).as_posix()], cwd=repo, check=True)
            subprocess.run(["git", "commit", "-qm", "age test versions"], cwd=repo, check=True)

            second = subprocess.run(
                [sys.executable, str(script)], cwd=repo, text=True, capture_output=True, check=False
            )
            self.assertEqual(0, second.returncode, second.stderr)
            self.assertEqual(names[2:], [name for name in names if (app_root / name).is_dir()])
            final_registry = json.loads(registry.read_text(encoding="utf-8"))
            self.assertEqual(set(names[2:]), set(final_registry["versions"]))


if __name__ == "__main__":
    unittest.main()
