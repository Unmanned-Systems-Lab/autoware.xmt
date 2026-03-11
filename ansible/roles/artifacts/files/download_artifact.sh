#!/usr/bin/env bash
set -euo pipefail

url="${1:?missing url}"
dest="${2:?missing dest}"
checksum="${3:?missing checksum}"
mode="${4:-644}"

checksum="${checksum#sha256:}"
partial="${dest}.download"

verify_checksum() {
  local target="$1"
  echo "${checksum}  ${target}" | sha256sum --check --status
}

download_partial() {
  local -a curl_args=(
    --location
    --fail
    --show-error
    --connect-timeout 20
    --retry 20
    --retry-delay 2
    --retry-all-errors
    --speed-limit 1024
    --speed-time 30
    --output "${partial}"
  )

  if [[ -s "${partial}" ]]; then
    curl_args+=(--continue-at -)
  fi

  curl "${curl_args[@]}" "${url}"
}

if [[ -f "${dest}" ]] && verify_checksum "${dest}"; then
  exit 0
fi

mkdir -p "$(dirname "${dest}")"

for attempt in 1 2; do
  download_partial
  if verify_checksum "${partial}"; then
    mv -f "${partial}" "${dest}"
    chmod "${mode}" "${dest}"
    exit 10
  fi

  rm -f "${partial}"
  if [[ "${attempt}" -eq 2 ]]; then
    echo "checksum verification failed for ${dest}" >&2
    exit 1
  fi
done
