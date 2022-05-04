#!/usr/bin/env bash
set -eux

DOCKER=${DOCKER:-docker}

mkdir -p tar

TAG="ubuntu-layer-${ARCH}"

${DOCKER} build \
    --tag "${TAG}" \
    --platform "linux/${ARCH_ALIAS}" \
    .

cd tar

${DOCKER} save "${TAG}" >${TAG}.tar
gzip ${TAG}.tar

# sha512sum is not on macOS by default, fixable with `brew install coreutils`
sha512sum "${TAG}.tar.gz" >"${TAG}.tar.gz.sha512sum"
