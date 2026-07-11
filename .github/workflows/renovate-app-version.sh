#!/usr/bin/env bash
set -euo pipefail

# This script renames a version directory to match the changed primary service image tag.

app_name=${1:?missing app name}
old_version=${2:?missing source version}
docker_compose_file=${3:?missing docker-compose path}
base_ref=${4:?missing base ref}
source_dir="apps/$app_name/$old_version"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
policy_file="$script_dir/../renovate-primary-services.json"
selector="$script_dir/../scripts/renovate_app_version.py"

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

trimmed_version=$(python3 "$selector" \
  --app "$app_name" \
  --old-version "$old_version" \
  --compose "$docker_compose_file" \
  --base-ref "$base_ref" \
  --policy-file "$policy_file")

if [[ -z "$trimmed_version" || "$trimmed_version" == "$old_version" ]]; then
  echo "skip: $source_dir already matches the selected primary image tag"
  exit 0
fi

target_dir="apps/$app_name/$trimmed_version"
if [[ -e "$target_dir" ]]; then
  echo "target already exists: $target_dir" >&2
  exit 1
fi

mv "$source_dir" "$target_dir"
