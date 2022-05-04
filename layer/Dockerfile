### docker
FROM docker:20.10 as docker

### base
FROM ubuntu:22.04

# disable apt prompts
ENV DEBIAN_FRONTEND=noninteractive

# install essential packages
RUN apt update && apt install -y --no-install-recommends \
    git \
    curl \
    wget \
    htop \
    tree \
    vim \
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
    && rm -rf /var/lib/apt/lists/*

# docker client
COPY --from=docker /usr/local/bin/docker /usr/local/bin/
