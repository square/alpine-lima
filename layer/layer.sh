#!/usr/bin/env bash
set -eu

DOCKER=${DOCKER:-docker}

mkdir -p tar

TAG="ubuntu-layer"
FILE="${TAG}-${ARCH}"

${DOCKER} build \
    --tag "${TAG}" \
    --platform "linux/${ARCH_ALIAS}" \
    .

cd tar

${DOCKER} save "${TAG}" >${FILE}.tar
gzip ${FILE}.tar

# sha512sum is not on macOS by default, fixable with `brew install coreutils`
sha512sum "${FILE}.tar.gz" >"${FILE}.tar.gz.sha512sum"
