### base
FROM ubuntu:22.04

# disable apt prompts
ENV DEBIAN_FRONTEND=noninteractive

# install essential packages
RUN apt update && apt install -y --no-install-recommends \
    tini \
    git \
    curl \
    wget \
    htop \
    tree \
    neovim \
    nano \
    make \
    gnupg \
    sudo \
    bash \
    zsh \
    tmux \
    xz-utils \
    inetutils-ping \
    iproute2 \
    net-tools \
    openssh-server \
    apt-transport-https \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates
