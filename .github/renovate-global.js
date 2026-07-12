const username = process.env.RENOVATE_DOCKERHUB_USERNAME;
const password = process.env.RENOVATE_DOCKERHUB_TOKEN;
const dockerConfig = require("./renovate-docker.json");
const dockerHubHosts = [
  "docker.io",
  "index.docker.io",
  "registry-1.docker.io",
];

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
  hostRules: dockerHubHosts.map((matchHost) => ({
    hostType: "docker",
    matchHost,
    username,
    password,
  })),
};
