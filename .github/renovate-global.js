const username = process.env.RENOVATE_DOCKERHUB_USERNAME;
const password = process.env.RENOVATE_DOCKERHUB_TOKEN;

if (!username || !password) {
  throw new Error(
    "Docker Hub credentials are required: configure DOCKERHUB_USERNAME and DOCKERHUB_TOKEN repository secrets.",
  );
}

module.exports = {
  hostRules: [
    {
      hostType: "docker",
      matchHost: "docker.io",
      username,
      password,
    },
  ],
};
