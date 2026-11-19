#!/usr/bin/env bash
# Installs a release of the Nullify CLI and prints the path of the binary.
#
# NULLIFY_VERSION  release to install, such as 0.29.0 (required)
# NULLIFY_OS_ARCH  release platform, such as linux_amd64; detected from the
#                  runner when empty
# INSTALL_DIR      directory to install into (default: $RUNNER_TEMP/nullify-cli)
set -euo pipefail

version="${NULLIFY_VERSION:?NULLIFY_VERSION is required}"
version="${version#v}"

detect_os_arch() {
  local os arch
  case "${RUNNER_OS:-$(uname -s)}" in
    Linux) os="linux" ;;
    macOS | Darwin) os="darwin" ;;
    *) echo "unsupported runner OS ${RUNNER_OS:-$(uname -s)}: set os-arch" >&2; return 1 ;;
  esac
  case "${RUNNER_ARCH:-$(uname -m)}" in
    X64 | x86_64 | amd64) arch="amd64" ;;
    ARM64 | arm64 | aarch64) arch="arm64" ;;
    *) echo "unsupported runner architecture ${RUNNER_ARCH:-$(uname -m)}: set os-arch" >&2; return 1 ;;
  esac
  echo "${os}_${arch}"
}

os_arch="${NULLIFY_OS_ARCH:-}"
if [ -z "$os_arch" ]; then
  os_arch="$(detect_os_arch)"
fi
if ! [[ "$os_arch" =~ ^(linux|darwin)_(amd64|arm64)$ ]]; then
  echo "unsupported os-arch ${os_arch}: use linux_amd64, linux_arm64, darwin_amd64 or darwin_arm64" >&2
  exit 1
fi

install_dir="${INSTALL_DIR:-${RUNNER_TEMP:-/tmp}/nullify-cli}"
archive="nullify_${os_arch}.tar.gz"
base_url="https://github.com/Nullify-Platform/cli/releases/download/v${version}"

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

curl -sSfL --retry 3 -o "${work_dir}/${archive}" "${base_url}/${archive}"
curl -sSfL --retry 3 -o "${work_dir}/checksums.txt" "${base_url}/checksums.txt"

expected="$(awk -v name="$archive" '$2 == name { print $1 }' "${work_dir}/checksums.txt")"
if [ -z "$expected" ]; then
  echo "checksums.txt of v${version} has no entry for ${archive}" >&2
  exit 1
fi
if command -v sha256sum >/dev/null 2>&1; then
  actual="$(sha256sum "${work_dir}/${archive}" | awk '{ print $1 }')"
else
  actual="$(shasum -a 256 "${work_dir}/${archive}" | awk '{ print $1 }')"
fi
if [ "$expected" != "$actual" ]; then
  echo "checksum mismatch for ${archive}: expected ${expected}, got ${actual}" >&2
  exit 1
fi

mkdir -p "$install_dir"
tar -xzf "${work_dir}/${archive}" -C "$install_dir" nullify
chmod +x "${install_dir}/nullify"
echo "${install_dir}/nullify"
