const username = process.env.RENOVATE_DOCKERHUB_USERNAME;
const password = process.env.RENOVATE_DOCKERHUB_TOKEN;
const dockerConfig = require("./renovate-docker.json");

if (!username || !password) {
  throw new Error(
    "Docker Hub credentials are required: configure DOCKERHUB_USERNAME and DOCKERHUB_TOKEN repository secrets.",
  );
}

module.exports = {
  ...dockerConfig,
  // Keep the self-hosted controller independent from the hosted App's root config.
  requireConfig: "ignored",
  onboarding: false,
  branchPrefix: "selfhosted-renovate/",
  dependencyDashboard: true,
  dependencyDashboardTitle: "Dependency Dashboard (Docker Images)",
  hostRules: [
    {
      hostType: "docker",
      matchHost: "docker.io",
      username,
      password,
    },
  ],
};
