# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/02 19:19:19 by jeportie          #+#    #+#              #
#    Updated: 2025/04/02 19:31:27 by jeportie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Base System Configuration ************************************************** #
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y locales locales-all python3-venv && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
WORKDIR /root

# Install all apt dependencies in one go
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
	clang \
	openssh-client \
    cmake \
    make \
    git \
    bear \
    tree \
    ripgrep \
    curl \
    wget \
    npm \
    expect \
    unzip \
    tar \
    p7zip-full \
    zsh \
    libreadline-dev \
    valgrind \
    check \
    lldb \
    libxext-dev \
    libx11-dev \
    libbsd-dev \
    x11-apps \
    xclip \
    python3-pip \
    python3-venv \
    libgtest-dev \
    lua5.3 \
    lua5.3-dev \
    lua5.1 \
    lua5.1-dev && \
    rm -rf /var/lib/apt/lists/*

# Create a Python virtual environment and install : 
# pip, setuptools, pynvim and norminette ************************************* #
RUN python3 -m venv /root/venv && \
    /root/venv/bin/pip install --upgrade pip setuptools pynvim
ENV VIRTUAL_ENV_DISABLE_PROMPT=1
ENV PATH="/root/venv/bin:${PATH}"

# Install & config docker shell UI ******************************************* #
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended && \
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="agnoster"/' ~/.zshrc
RUN chsh -s $(which zsh)
RUN touch ~/.zsh_history && chmod 600 ~/.zsh_history
RUN npm i @vscode/codicons
COPY custom/custom_agnoster.zsh-theme /root/.oh-my-zsh/themes/agnoster.zsh-theme

# Install Node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    . ~/.nvm/nvm.sh && \
    nvm install node

# Install UV installer.
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
