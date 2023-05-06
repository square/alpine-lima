#!/usr/bin/env bash
set -eu

# Ensure this variable is defined (defaulting to empty string) to appease `set -u` above
GITHUB_ACTIONS=${GITHUB_ACTIONS:-}

DOCKER=${DOCKER:-docker}

mkdir -p iso

TAG="${EDITION}-${ALPINE_VERSION}"

source "edition/${EDITION}"

${DOCKER} run --rm \
    --platform "linux/${ARCH_ALIAS}" \
    -v "${PWD}/iso:/iso" \
    -v "${PWD}/mkimg.lima.sh:/home/build/aports/scripts/mkimg.lima.sh:ro" \
    -v "${PWD}/genapkovl-lima.sh:/home/build/aports/scripts/genapkovl-lima.sh:ro" \
    -v "${PWD}/lima-init.sh:/home/build/lima-init.sh:ro" \
    -v "${PWD}/lima-init.openrc:/home/build/lima-init.openrc:ro" \
    -v "${PWD}/lima-init-local.openrc:/home/build/lima-init-local.openrc:ro" \
    -v "${PWD}/lima-buildkitd.openrc:/home/build/lima-buildkitd.openrc:ro" \
    -v "${PWD}/lima-network.awk:/home/build/lima-network.awk:ro" \
    -v "${PWD}/nerdctl-${NERDCTL_VERSION}-${ARCH}:/home/build/nerdctl.tar.gz:ro" \
    -v "${PWD}/qemu-${QEMU_VERSION}-copying:/home/build/qemu-copying:ro" \
    -v "${PWD}/cri-dockerd-${CRI_DOCKERD_VERSION}-${ARCH}:/home/build/cri-dockerd.tar.gz:ro" \
    -v "${PWD}/cri-dockerd-${CRI_DOCKERD_VERSION}-${ARCH}.LICENSE:/home/build/cri-dockerd.license:ro" \
    -v "${PWD}/sshd.pam:/home/build/sshd.pam:ro" \
    -v "${PWD}/layer/tar/ubuntu-layer-${ARCH}.tar.gz:/home/build/ubuntu-layer.tar.gz:ro" \
    $(env | grep ^LIMA_ | xargs -n 1 printf -- '-e %s ') \
    -e "LIMA_REPO_VERSION=${REPO_VERSION}" \
    -e "LIMA_BUILD_ID=${BUILD_ID}" \
    -e "LIMA_VARIANT_ID=${EDITION}" \
    "mkimage:${ALPINE_VERSION}-${ARCH}" \
    --tag "${TAG}" \
    --outdir /iso \
    --arch "${ARCH}" \
    --repository "/home/build/packages/lima" \
    --repository "http://dl-cdn.alpinelinux.org/alpine/${REPO_VERSION}/main" \
    --repository "http://dl-cdn.alpinelinux.org/alpine/${REPO_VERSION}/community" \
    --profile lima

cd iso

ISO="alpine-lima-${EDITION}-${ALPINE_VERSION}-${ARCH}.iso"

if [ -n "$GITHUB_ACTIONS" ]; then
    # To prevent "Cannot set the file group: Operation not permitted" error when running `xz` on the ISO file below
    sudo chown $(id -u):$(id -g) "${ISO}"
fi

# --threads=0 means "use all available CPU cores"
# --force ensures any existing artifact is deleted so we can replace it
xz --force --threads=0 "${ISO}"
ISO_XZ="${ISO}.xz"

openssl sha512 -r "${ISO_XZ}" > "${ISO_XZ}.sha512sum"
