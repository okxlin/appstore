#!/usr/bin/env bash
set -euo pipefail

# This script renames a version directory to match the image tag from its compose file.

app_name=${1:?missing app name}
old_version=${2:?missing source version}
source_dir="apps/$app_name/$old_version"

case "$old_version" in
  latest|stable)
    echo "skip: $source_dir is a rolling alias"
    exit 0
    ;;
esac

if [[ ! -d "$source_dir" ]]; then
  echo "skip: $source_dir does not exist"
  exit 0
fi

# Find all docker-compose files under apps/$app_name/$old_version (there should be only one).
docker_compose_files=$(find "$source_dir" -name docker-compose.yml)

for docker_compose_file in $docker_compose_files; do
  # Assume the app version comes from the first service image.
  first_service=$(yq '.services | keys | .[0]' "$docker_compose_file")
  image=$(yq ".services.${first_service}.image" "$docker_compose_file")

  # Only apply changes if the format is <image>:<version>.
  if [[ "$image" != *":"* ]]; then
    continue
  fi

  version=$(cut -d ":" -f2- <<< "$image")
  trimmed_version=${version/#"v"}

  if [[ -z "$trimmed_version" || "$trimmed_version" == "$old_version" ]]; then
    echo "skip: $source_dir already matches image tag $version"
    continue
  fi

  target_dir="apps/$app_name/$trimmed_version"
  if [[ -e "$target_dir" ]]; then
    echo "target already exists: $target_dir" >&2
    exit 1
  fi

  mv "$source_dir" "$target_dir"
done
