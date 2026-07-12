const AUTH_URL =
  "https://auth.docker.io/token?service=registry.docker.io&scope=repository:library/alpine:pull";
const MANIFEST_URL =
  "https://registry-1.docker.io/v2/library/alpine/manifests/latest";

export async function checkDockerHubCredentials({
  username,
  password,
  fetchImpl = fetch,
}) {
  if (!username || !password) {
    throw new Error(
      "Configure DOCKERHUB_USERNAME and DOCKERHUB_TOKEN repository secrets.",
    );
  }

  const basicAuth = Buffer.from(`${username}:${password}`).toString("base64");
  const authResponse = await fetchImpl(AUTH_URL, {
    headers: { authorization: `Basic ${basicAuth}` },
  });
  if (!authResponse.ok) {
    throw new Error(
      `Docker Hub rejected the configured credentials (HTTP ${authResponse.status}).`,
    );
  }

  const authPayload = await authResponse.json();
  const bearer = authPayload.token ?? authPayload.access_token;
  if (!bearer) {
    throw new Error("Docker Hub did not return a registry bearer token.");
  }

  const manifestResponse = await fetchImpl(MANIFEST_URL, {
    headers: {
      accept:
        "application/vnd.docker.distribution.manifest.list.v2+json, application/vnd.oci.image.index.v1+json",
      authorization: `Bearer ${bearer}`,
    },
  });
  if (!manifestResponse.ok) {
    throw new Error(
      `Docker Hub authenticated manifest lookup failed (HTTP ${manifestResponse.status}).`,
    );
  }

  return {
    limit:
      manifestResponse.headers.get("ratelimit-limit") ??
      manifestResponse.headers.get("x-ratelimit-limit") ??
      "not reported",
    remaining:
      manifestResponse.headers.get("ratelimit-remaining") ??
      manifestResponse.headers.get("x-ratelimit-remaining") ??
      "not reported",
  };
}

if (
  process.argv[1] &&
  import.meta.url === pathToFileURL(resolve(process.argv[1])).href
) {
  try {
    const result = await checkDockerHubCredentials({
      username: process.env.RENOVATE_DOCKERHUB_USERNAME,
      password: process.env.RENOVATE_DOCKERHUB_TOKEN,
    });
    console.log(
      `Docker Hub credential preflight passed (limit=${result.limit}, remaining=${result.remaining}).`,
    );
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
  }
}
import { resolve } from "node:path";
import { pathToFileURL } from "node:url";
