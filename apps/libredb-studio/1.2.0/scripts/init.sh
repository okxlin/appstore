#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-$ROOT_DIR/.env}"

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s\n' "$value"
}

read_env_value() {
  local key="$1"
  [[ -f "$ENV_FILE" ]] || return 0
  local value
  # Read as the compose file reads it, trimmed before quotes come off.
  value="$(sed -n \
    -e "s/^[[:space:]]*export[[:space:]]\{1,\}${key}[[:space:]]*=//p;t" \
    -e "s/^[[:space:]]*${key}[[:space:]]*=//p" \
    "$ENV_FILE" | tail -n 1)"
  value="$(trim "$value")"
  case "$value" in
    \"*\") value="${value#\"}"; value="${value%\"}" ;;
    \'*\') value="${value#\'}"; value="${value%\'}" ;;
  esac
  printf '%s\n' "$value"
}

env_has_key() {
  local key="$1"
  [[ -f "$ENV_FILE" ]] || return 1
  grep -qE "^[[:space:]]*(export[[:space:]]+)?${key}[[:space:]]*=" "$ENV_FILE"
}

# A value that is set but empty is not defaulted. Compose refuses the project on
# one, so saying why here beats letting it fail with an opaque mount spec.
configured_value() {
  local key="$1"
  local default_value="$2"
  local value
  if [[ -n "${!key+x}" ]]; then
    value="$(trim "${!key}")"
    if [[ -z "$value" ]]; then
      printf '%s\n' "unsafe ${key} path: ${key} is set to an empty value" >&2
      return 1
    fi
    printf '%s\n' "$value"
    return 0
  fi
  value="$(read_env_value "$key")"
  if [[ -z "$value" ]] && env_has_key "$key"; then
    printf '%s\n' "unsafe ${key} path: ${key} in .env has an empty value" >&2
    return 1
  fi
  printf '%s\n' "${value:-$default_value}"
}

# Resolves . and .. textually, as the daemon cleans a bind source. realpath
# resolves symlinks first and lands elsewhere when one precedes a .. .
lexclean() {
  local path="$1"
  local part out="" absolute=0 n=0 i
  local -a parts=() stack=()
  [[ "$path" == /* ]] && absolute=1
  IFS='/' read -r -a parts <<< "$path"
  for part in ${parts[@]+"${parts[@]}"}; do
    case "$part" in
      ''|.) continue ;;
      ..)
        if (( n > 0 )) && [[ "${stack[n-1]}" != ".." ]]; then
          n=$(( n - 1 ))
        elif (( absolute == 0 )); then
          stack[n]=".."; n=$(( n + 1 ))
        fi
        ;;
      *) stack[n]="$part"; n=$(( n + 1 )) ;;
    esac
  done
  for (( i = 0; i < n; i++ )); do
    out="$out/${stack[i]}"
  done
  if (( absolute )); then
    printf '%s\n' "${out:-/}"
  else
    printf '%s\n' "${out#/}"
  fi
}

# An absolute value is kept, so an upgrade finds the data where the installation
# keeps it. A relative value stays under the app directory.
resolve_app_path() {
  local key="$1"
  local raw="$2"
  local rest clean candidate resolved current part
  local -a parts=()

  [[ -n "$raw" ]] || { printf '%s\n' "unsafe ${key} path" >&2; return 1; }
  if [[ "$raw" =~ [[:cntrl:]] ]]; then
    printf '%s\n' "unsafe ${key} path" >&2
    return 1
  fi
  # The compose file parses the same value and reads these differently.
  case "$raw" in
    *'$'*|*:*|'#'*|*[[:space:]]'#'*|*\\*|*\"*|*\'*)
      printf '%s\n' "unsafe ${key} path: remove the \$ : \\ \" ' or word-opening # from ${key} in .env, because the compose file reads those and would mount a different directory than this script creates" >&2
      return 1 ;;
  esac

  if [[ "$raw" == '~'* ]]; then
    if [[ -z "${HOME:-}" ]]; then
      printf '%s\n' "unsafe ${key} path: ~ cannot be resolved because HOME is not set" >&2
      return 1
    fi
    rest="${raw#\~}"; rest="${rest#/}"
    raw="${HOME%/}${rest:+/$rest}"
  fi

  if [[ "$raw" == /* ]]; then
    resolved="$(lexclean "$raw")"
    if [[ "$resolved" == "/" ]]; then
      printf '%s\n' "unsafe ${key} path: the root directory cannot hold the app data" >&2
      return 1
    fi
    current=""
    IFS='/' read -r -a parts <<< "$resolved"
    for part in ${parts[@]+"${parts[@]}"}; do
      [[ -z "$part" ]] && continue
      current="$current/$part"
      if [[ -L "$current" && ! -e "$current" ]]; then
        printf '%s\n' "unsafe ${key} path: ${current} is a link that does not resolve to an existing path" >&2
        return 1
      fi
    done
    if [[ -e "$resolved" && ! -d "$resolved" ]]; then
      printf '%s\n' "unsafe ${key} path: ${resolved} exists and is not a directory" >&2
      return 1
    fi
    printf '%s\n' "$resolved"
    return 0
  fi

  # Compose reads a bare name as a named volume and refuses the whole project.
  if [[ "$raw" != .* ]]; then
    printf '%s\n' "unsafe ${key} path: a relative value has to begin with a dot, as ./data does" >&2
    return 1
  fi
  case "$raw" in
    .|..|../*|*/../*|*/..) printf '%s\n' "unsafe ${key} path" >&2; return 1 ;;
  esac
  clean="$(lexclean "$raw")"
  [[ -n "$clean" ]] || { printf '%s\n' "unsafe ${key} path" >&2; return 1; }
  candidate="$ROOT_DIR/$clean"
  case "$candidate" in
    "$ROOT_DIR"/*) ;;
    *) printf '%s\n' "unsafe ${key} path" >&2; return 1 ;;
  esac
  current="$ROOT_DIR"
  IFS='/' read -r -a parts <<< "$clean"
  for part in ${parts[@]+"${parts[@]}"}; do
    [[ -z "$part" || "$part" == "." ]] && continue
    current="$current/$part"
    if [[ -L "$current" ]]; then
      printf '%s\n' "unsafe ${key} path" >&2
      return 1
    fi
  done
  if [[ -e "$candidate" && ! -d "$candidate" ]]; then
    printf '%s\n' "unsafe ${key} path: ${candidate} exists and is not a directory" >&2
    return 1
  fi
  printf '%s\n' "$candidate"
}

ensure_dir() {
  local key="$1"
  local raw path
  raw="$(configured_value "$key" "$2")"
  path="$(resolve_app_path "$key" "$raw")"
  mkdir -p -- "$path"
}

ensure_dir "APP_DATA_DIR_1" "./data"
