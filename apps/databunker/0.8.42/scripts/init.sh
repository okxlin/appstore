#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ENV_FILE="${ENV_FILE:-${ROOT_DIR}/.env}"

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}

read_env_value() {
  local key="$1" value

  value="$(awk -v key="${key}" 'index($0, key "=") == 1 { value = substr($0, length(key) + 2) } END { print value }' "${ENV_FILE}")"
  if [[ ${#value} -ge 2 && "${value:0:1}" == "${value: -1}" && "${value:0:1}" =~ [\"\'] ]]; then
    value="${value:1:${#value}-2}"
  fi
  printf '%s\n' "${value}"
}

write_env_value() {
  local key="$1" value="$2" temp_file

  temp_file="$(mktemp "${ENV_FILE}.tmp.XXXXXX")"
  awk -v key="${key}" -v value="${value}" '
    BEGIN { written = 0 }
    index($0, key "=") == 1 {
      if (!written) { print key "=" value; written = 1 }
      next
    }
    { print }
    END { if (!written) print key "=" value }
  ' "${ENV_FILE}" >"${temp_file}"
  chmod --reference="${ENV_FILE}" "${temp_file}"
  mv -f -- "${temp_file}" "${ENV_FILE}"
}

generate_master_key() {
  od -An -N24 -tx1 /dev/urandom | tr -d ' \n'
}

generate_root_token() {
  [[ -r /proc/sys/kernel/random/uuid ]] || fail "The host UUID generator is unavailable"
  tr 'A-F' 'a-f' </proc/sys/kernel/random/uuid
}

write_secret_file() {
  local path="$1" value="$2" temp_file

  temp_file="$(mktemp "${path}.tmp.XXXXXX")"
  chmod 0600 "${temp_file}"
  printf '%s\n' "${value}" >"${temp_file}"
  mv -f -- "${temp_file}" "${path}"
}

[[ -f "${ENV_FILE}" && ! -L "${ENV_FILE}" ]] || fail "${ENV_FILE} must be a regular file"
chmod 0600 -- "${ENV_FILE}"
command -v realpath >/dev/null 2>&1 || fail "realpath is required"
command -v od >/dev/null 2>&1 || fail "od is required"

data_raw="$(read_env_value APP_DATA_DIR)"
data_raw="${data_raw:-./data}"
case "${data_raw}" in
  *$'\n'* | *$'\r'* | *\$\(* | *\`*) fail "APP_DATA_DIR contains unsupported characters" ;;
esac
case "${data_raw}" in
  /*) data_dir="$(realpath -m -- "${data_raw}")" ;;
  *)
    data_dir="$(realpath -m -- "${ROOT_DIR}/${data_raw#./}")"
    [[ "${data_dir}" == "${ROOT_DIR}/"* ]] || fail "Relative APP_DATA_DIR must stay inside the application directory"
    ;;
esac
[[ "${data_dir}" != / && "${data_dir}" != "${ROOT_DIR}" ]] || fail "APP_DATA_DIR must not be a filesystem or application root"
[[ ! -L "${data_dir}" ]] || fail "APP_DATA_DIR must not be a symbolic link"

credentials_dir="${data_dir}/credentials"
runtime_dir="${data_dir}/runtime"
for path in "${credentials_dir}" "${runtime_dir}"; do
  [[ ! -L "${path}" ]] || fail "${path} must not be a symbolic link"
done

umask 077
mkdir -p -- "${credentials_dir}" "${runtime_dir}"
chmod 0700 "${credentials_dir}"
chmod 0750 "${runtime_dir}"
chown 100:101 "${runtime_dir}"

master_file="${credentials_dir}/master-key"
root_file="${credentials_dir}/root-token"
master_key=""
root_token=""

if [[ -e "${master_file}" || -L "${master_file}" ]]; then
  [[ -f "${master_file}" && ! -L "${master_file}" ]] || fail "${master_file} must be a regular file"
  master_key="$(<"${master_file}")"
  [[ "${master_key}" =~ ^[0-9A-Fa-f]{48}$ ]] || fail "${master_file} contains an invalid DataBunker master key"
fi
if [[ -z "${master_key}" ]]; then
  master_key="$(read_env_value DATABUNKER_MASTER_KEY)"
  [[ "${master_key}" =~ ^[0-9A-Fa-f]{48}$ ]] || master_key="$(generate_master_key)"
fi
[[ "${master_key}" =~ ^[0-9a-f]{48}$ ]] || master_key="$(printf '%s' "${master_key}" | tr 'A-F' 'a-f')"
[[ "${master_key}" =~ ^[0-9a-f]{48}$ ]] || fail "Could not create a valid DataBunker master key"

if [[ -e "${root_file}" || -L "${root_file}" ]]; then
  [[ -f "${root_file}" && ! -L "${root_file}" ]] || fail "${root_file} must be a regular file"
  root_token="$(<"${root_file}")"
  [[ "${root_token}" =~ ^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[1-5][0-9A-Fa-f]{3}-[89AaBb][0-9A-Fa-f]{3}-[0-9A-Fa-f]{12}$ ]] || fail "${root_file} contains an invalid DataBunker root token"
fi
if [[ -z "${root_token}" ]]; then
  root_token="$(read_env_value DATABUNKER_ROOTTOKEN)"
  if [[ ! "${root_token}" =~ ^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[1-5][0-9A-Fa-f]{3}-[89AaBb][0-9A-Fa-f]{3}-[0-9A-Fa-f]{12}$ ]]; then
    root_token="$(generate_root_token)"
  fi
fi
root_token="$(printf '%s' "${root_token}" | tr 'A-F' 'a-f')"
[[ "${root_token}" =~ ^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$ ]] || fail "Could not create a valid DataBunker root token"

write_secret_file "${master_file}" "${master_key}"
write_secret_file "${root_file}" "${root_token}"
write_env_value DATABUNKER_MASTER_KEY "${master_key}"
write_env_value DATABUNKER_ROOTTOKEN "${root_token}"

printf '%s\n' "DataBunker credentials are stored in the configured data directory."
