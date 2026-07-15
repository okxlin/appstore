#!/usr/bin/env python3
import unittest
from pathlib import Path

import yaml


REPO_ROOT = Path(__file__).resolve().parents[2]
WORKFLOW_PATH = REPO_ROOT / ".github" / "workflows" / "label-third-party-prs.yml"


class LabelThirdPartyWorkflowTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.workflow_text = WORKFLOW_PATH.read_text(encoding="utf-8")
        cls.workflow = yaml.load(cls.workflow_text, Loader=yaml.BaseLoader)

    def test_keeps_the_existing_event_scope_and_minimal_permission(self) -> None:
        self.assertEqual(
            ["opened", "reopened"],
            self.workflow["on"]["pull_request_target"]["types"],
        )
        self.assertEqual({"pull-requests": "write"}, self.workflow["permissions"])

        condition = self.workflow["jobs"]["add-pending-label"]["if"]
        self.assertIn("app/renovate", condition)
        self.assertIn("renovate[bot]", condition)
        self.assertIn("selfhosted-renovate/", condition)

    def test_adds_the_pending_label_with_authenticated_github_cli(self) -> None:
        step = self.workflow["jobs"]["add-pending-label"]["steps"][0]
        self.assertNotIn("uses", step)
        self.assertEqual(
            {
                "GH_TOKEN": "${{ secrets.GITHUB_TOKEN }}",
                "GH_REPO": "${{ github.repository }}",
                "PR_NUMBER": "${{ github.event.pull_request.number }}",
            },
            step["env"],
        )
        self.assertIn("gh api --method POST", step["run"])
        self.assertIn("--silent", step["run"])
        self.assertIn('repos/${GH_REPO}/issues/${PR_NUMBER}/labels', step["run"])
        self.assertIn("labels[]=pending", step["run"])
        self.assertIn("echo 'labels: pending'", step["run"])


if __name__ == "__main__":
    unittest.main()
