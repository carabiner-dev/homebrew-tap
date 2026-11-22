#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright 2026 Carabiner Systems, Inc
# SPDX-License-Identifier: Apache-2.0
#
# Points Formula/drop.rb to a drop release.
#
# drop is the bootstrap of the tap, so its formula pins the sha256 of the
# release binaries. This script never hashes a plain download: every binary
# is fetched with an already installed drop, which refuses to write it unless
# its SLSA provenance passes drop's release policy. Each release is this way
# vouched for by the previous one before its hashes land in the tap.
#
# Usage: hack/update-drop.sh v1.2.3

set -euo pipefail

TAG="${1:?usage: $0 <tag>}"
if [[ ! "$TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?$ ]]; then
  echo "error: '${TAG}' does not look like a version tag" >&2
  exit 1
fi

REPO="carabiner-dev/drop"
FORMULA="$(cd "$(dirname "$0")/.." && pwd)/Formula/drop.rb"
PLATFORMS=(darwin/arm64 linux/arm64 linux/amd64)

command -v drop >/dev/null || {
  echo "error: drop is required to verify the release (brew install carabiner-dev/tap/drop)" >&2
  exit 1
}

sha256() {
  if command -v sha256sum >/dev/null; then sha256sum "$1"; else shasum -a 256 "$1"; fi | awk '{print $1}'
}

# Sets the sha256 following the url line that ends in $1
pin() {
  URL_END="$1" SHA="$2" perl -0pi -e '
    my $n = s/(url "[^"\n]*\Q$ENV{URL_END}\E"\n\s*sha256 ")[0-9a-f]{64}(")/$1$ENV{SHA}$2/;
    die "no url ending in $ENV{URL_END} in the formula\n" unless $n == 1;
  ' "$FORMULA"
}

CURRENT="$(grep -oE 'releases/download/v[^/]+' "$FORMULA" | head -1 | cut -d/ -f3)"
[ -n "$CURRENT" ] || { echo "error: could not read the current version from ${FORMULA}" >&2; exit 1; }

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# Move every url to the new tag, then pin each download
CURRENT="$CURRENT" TAG="$TAG" perl -pi -e 's/\Q$ENV{CURRENT}\E/$ENV{TAG}/g if /^\s*url /' "$FORMULA"

for platform in "${PLATFORMS[@]}"; do
  slug="${platform/\//-}"
  drop get "${REPO}@${TAG}" --platform "$platform" --quiet --directory "${WORK}/${slug}"
  pin "drop-${TAG}-${slug}" "$(sha256 "${WORK}/${slug}/drop")"
done

# The sources Intel macs build from. There is no provenance for the tarball,
# it is pinned as downloaded.
curl -fsSL -o "${WORK}/source.tar.gz" "https://github.com/${REPO}/archive/refs/tags/${TAG}.tar.gz"
pin "refs/tags/${TAG}.tar.gz" "$(sha256 "${WORK}/source.tar.gz")"

echo "${FORMULA}: ${CURRENT} -> ${TAG}"
