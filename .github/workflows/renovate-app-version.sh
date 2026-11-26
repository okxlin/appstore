#!/usr/bin/env bash
set -euo pipefail

# This script adds an image-tagged version directory and retires an obsolete numeric source version.

app_name=${1:?missing app name}
old_version=${2:?missing source version}
docker_compose_file=${3:?missing docker-compose path}
base_ref=${4:?missing base ref}
source_dir="apps/$app_name/$old_version"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
policy_file="$script_dir/../renovate-primary-services.json"
renovate_config="$script_dir/../renovate-docker.json"
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
prune_source=$(python3 "$selector" \
  --check-prune-source \
  --app "$app_name" \
  --old-version "$old_version" \
  --target-version "$trimmed_version" \
  --renovate-config "$renovate_config")

if [[ -e "$target_dir" ]]; then
  git restore --source="$base_ref" --staged --worktree -- "$source_dir"
  if [[ -d "$target_dir" ]] \
    && git cat-file -e "$base_ref:$target_dir/docker-compose.yml" 2>/dev/null \
    && [[ "$prune_source" == "true" ]]; then
    git rm -r -f -- "$source_dir"
    echo "removed obsolete numeric version directory because target already exists: $source_dir"
  else
    echo "skip: $target_dir already exists; restored the Renovate-edited source version"
  fi
  exit 0
fi

cp -a "$source_dir" "$target_dir"
git restore --source="$base_ref" --staged --worktree -- "$source_dir"

if [[ "$prune_source" == "true" ]]; then
  git rm -r -f -- "$source_dir"
  echo "removed obsolete numeric version directory: $source_dir"
else
  echo "retained source version directory: $source_dir"
fi
