### base
FROM ubuntu:23.04

# disable apt prompts
ENV DEBIAN_FRONTEND=noninteractive

# install essential packages
RUN apt update && apt install -y --no-install-recommends \
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
    systemd \
    && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates
