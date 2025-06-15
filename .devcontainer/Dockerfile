# Start from an official Python image. Pinning the version ensures reproducibility.
# Ayon requires Python 3.9.
ARG PYTHON_VERSION=3.9.23
FROM python:${PYTHON_VERSION}-slim-bookworm

# Metadata as described in
# https://docs.docker.com/engine/reference/builder/#metadata
LABEL maintainer="Gishant Singh <khiladisngh@hotmail.com>"
LABEL description="Ayon development container with Python 3.9, Zsh, and essential tools."
LABEL version="1.0"
LABEL python.version="${PYTHON_VERSION}"
LABEL uv.version="latest"

# --- Build Arguments ---
# These arguments can be overridden in the devcontainer.json file or during docker build.
# DEBIAN_FRONTEND: Prevents interactive prompts during package installations.
ARG DEBIAN_FRONTEND=noninteractive
# USERNAME, USER_UID, USER_GID: Define the non-root user for the container.
# Using a non-root user is a security best practice.
ARG USERNAME=ayondev
ARG USER_UID=1000
ARG USER_GID=${USER_UID} # Default GID to UID if not specified

# --- Environment Variables ---
# Set environment variables for the container.
# DEBIAN_FRONTEND: Used by apt-get to avoid interactive dialogs.
ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND}
# Python specific environment variables:
# PYTHONUNBUFFERED: Ensures Python output is sent straight to terminal (useful for logs).
# PIP_NO_CACHE_DIR: Disables pip's caching, reducing image size.
# PYTHONDONTWRITEBYTECODE: Prevents Python from writing .pyc files.
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1
# PATH: Prepend the user's local bin directory to PATH.
# This is where tools installed by the user (e.g., via pipx or Starship script) will reside.
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

# --- Script Directories ---
# Define paths for script management
ENV SCRIPTS_DIR="/tmp/scripts"

# --- System Setup (executed as root) ---
# The following commands are executed as the root user by default.

# Update package lists and install essential system-level dependencies.
# - git, sudo, curl, wget: Core command-line utilities.
# - build-essential & various -dev libraries: Needed for compiling some Python packages from source.
# - ca-certificates: For secure HTTPS connections.
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    sudo \
    curl \
    wget \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    ca-certificates \
    # Added tools for .zshrc aliases and fzf
    fzf \
    exa \
    bat \
    fd-find \
    ripgrep \
    # Add zsh package
    zsh \
    # Clean up apt cache to reduce image size.
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- User Creation (executed as root) ---
# Create a non-root user with specified UID/GID and sudo privileges.
# The user's home directory (/home/${USERNAME}) is created automatically by useradd -m.
RUN groupadd --gid ${USER_GID} ${USERNAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} -s /bin/zsh && \
    # Grant passwordless sudo privileges to the created user.
    echo "${USERNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}
# Note: At this point, /home/${USERNAME} is owned by ${USERNAME}:${USERNAME}.

# --- Copy and Setup Scripts ---
# Copy all scripts from the local scripts directory to the container
COPY scripts/ ${SCRIPTS_DIR}/
# Make all scripts executable
RUN find ${SCRIPTS_DIR} -type f -name "*.sh" -exec chmod +x {} \;

# --- Switch to Non-Root User ---
# All subsequent commands in the Dockerfile will be executed as ${USERNAME}.
USER ${USERNAME}

# --- Install ZSH and Starship ---
# Install Zsh configuration and Starship prompt as standard tools.
RUN ${SCRIPTS_DIR}/install-zsh.sh

# Set the default working directory for the container when it starts.
# Project files are typically mounted here.
WORKDIR /workspaces/ayon-dev