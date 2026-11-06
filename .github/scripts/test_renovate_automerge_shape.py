#!/usr/bin/env python3
from __future__ import annotations

import json
import pathlib
import shutil
import subprocess
import sys
import tempfile
import unittest


SCRIPT = pathlib.Path(__file__).with_name("renovate_automerge_shape.py")


def git(repo: pathlib.Path, *args: str) -> str:
    result = subprocess.run(
        ["git", *args], cwd=repo, check=True, text=True, capture_output=True
    )
    return result.stdout.strip()


class RenovateAutomergeShapeTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="renovate-automerge-shape-")
        self.repo = pathlib.Path(self.temp.name)
        subprocess.run(["git", "init", "-q"], cwd=self.repo, check=True)
        git(self.repo, "config", "user.email", "test@example.com")
        git(self.repo, "config", "user.name", "Test User")
        source = self.repo / "apps" / "demo" / "1.0.0"
        source.mkdir(parents=True)
        (source / "docker-compose.yml").write_text(
            "services:\n  app:\n    image: example/demo:1.0.0\n    restart: unless-stopped\n",
            encoding="utf-8",
        )
        (source / "data.yml").write_text("additionalProperties: {}\n", encoding="utf-8")
        (source / ".env.sample").write_text("APP_DATA_DIR=./data\n", encoding="utf-8")
        subprocess.run(["git", "add", "apps"], cwd=self.repo, check=True)
        subprocess.run(["git", "commit", "-qm", "add source package"], cwd=self.repo, check=True)
        self.base_sha = git(self.repo, "rev-parse", "HEAD")

    def tearDown(self):
        self.temp.cleanup()

    def run_gate(self, files: list[dict[str, str]]) -> subprocess.CompletedProcess[str]:
        head_sha = git(self.repo, "rev-parse", "HEAD")
        files_path = self.repo / "pr-files.json"
        output_path = self.repo / "shape.json"
        files_path.write_text(json.dumps(files), encoding="utf-8")
        return subprocess.run(
            [
                sys.executable,
                str(SCRIPT),
                "--base-sha",
                self.base_sha,
                "--head-sha",
                head_sha,
                "--files-json",
                str(files_path),
                "--output-json",
                str(output_path),
            ],
            cwd=self.repo,
            text=True,
            capture_output=True,
            check=False,
        )

    def add_version_copy(self, *, modify_data: bool = False) -> list[dict[str, str]]:
        source = self.repo / "apps" / "demo" / "1.0.0"
        target = self.repo / "apps" / "demo" / "1.1.0"
        shutil.copytree(source, target)
        compose = target / "docker-compose.yml"
        compose.write_text(
            compose.read_text(encoding="utf-8").replace("example/demo:1.0.0", "example/demo:1.1.0"),
            encoding="utf-8",
        )
        if modify_data:
            (target / "data.yml").write_text("additionalProperties:\n  unexpected: true\n", encoding="utf-8")
        subprocess.run(["git", "add", "apps/demo/1.1.0"], cwd=self.repo, check=True)
        subprocess.run(["git", "commit", "-qm", "add target version"], cwd=self.repo, check=True)
        return [
            {"filename": path.relative_to(self.repo).as_posix(), "status": "added"}
            for path in sorted(target.rglob("*"))
            if path.is_file()
        ]

    def test_accepts_new_version_that_only_changes_image(self):
        files = self.add_version_copy()
        result = self.run_gate(files)
        self.assertEqual(0, result.returncode, result.stderr)
        payload = json.loads((self.repo / "shape.json").read_text(encoding="utf-8"))
        self.assertEqual("added-version-package", payload["kind"])
        self.assertFalse(payload["digest_only"])

    def test_rejects_new_version_with_non_image_package_drift(self):
        files = self.add_version_copy(modify_data=True)
        result = self.run_gate(files)
        self.assertEqual(42, result.returncode, result.stderr)
        self.assertIn("does not exactly copy a base package", result.stderr)

    def test_accepts_existing_single_service_image_only_update(self):
        compose_path = self.repo / "apps" / "demo" / "1.0.0" / "docker-compose.yml"
        compose_path.write_text(
            compose_path.read_text(encoding="utf-8").replace("example/demo:1.0.0", "example/demo:1.1.0"),
            encoding="utf-8",
        )
        subprocess.run(["git", "add", "apps/demo/1.0.0/docker-compose.yml"], cwd=self.repo, check=True)
        subprocess.run(["git", "commit", "-qm", "update image"], cwd=self.repo, check=True)
        result = self.run_gate(
            [{"filename": "apps/demo/1.0.0/docker-compose.yml", "status": "modified"}]
        )
        self.assertEqual(0, result.returncode, result.stderr)
        payload = json.loads((self.repo / "shape.json").read_text(encoding="utf-8"))
        self.assertEqual("compose-update", payload["kind"])
        self.assertFalse(payload["digest_only"])

    def test_rejects_non_compose_file_in_existing_update(self):
        compose_path = self.repo / "apps" / "demo" / "1.0.0" / "docker-compose.yml"
        compose_path.write_text(
            compose_path.read_text(encoding="utf-8").replace("example/demo:1.0.0", "example/demo:1.1.0"),
            encoding="utf-8",
        )
        env_path = self.repo / "apps" / "demo" / "1.0.0" / ".env.sample"
        env_path.write_text("APP_DATA_DIR=/unexpected\n", encoding="utf-8")
        subprocess.run(["git", "add", "apps/demo/1.0.0"], cwd=self.repo, check=True)
        subprocess.run(["git", "commit", "-qm", "change compose and env"], cwd=self.repo, check=True)
        result = self.run_gate(
            [
                {"filename": "apps/demo/1.0.0/docker-compose.yml", "status": "modified"},
                {"filename": "apps/demo/1.0.0/.env.sample", "status": "modified"},
            ]
        )
        self.assertEqual(42, result.returncode, result.stderr)
        self.assertIn("non-Compose file", result.stderr)


if __name__ == "__main__":
    unittest.main()
