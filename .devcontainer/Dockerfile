# Use a Microsoft-provided Python 3.9 dev container image as our base.
# This gives us a solid foundation with Python and essential tools pre-installed.
FROM mcr.microsoft.com/devcontainers/python:0-3.9

# Define arguments that can be passed during the build process.
# This makes our Dockerfile more flexible. We'll get USERNAME from devcontainer.json.
ARG USERNAME=ayondev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Switch to root to install system-level packages.
USER root

# Install essential developer tools and shell enhancements using apt-get.
# This is where we add all the cool CLI tools you wanted.
# We also install fontconfig to ensure the font cache can be rebuilt.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    bash \
    zsh \
    curl \
    git \
    gnupg \
    exa \
    ripgrep \
    fzf \
    fontconfig \
    sudo \
    # We add a symlink because the 'bat' command is 'batcat' on Debian-based systems.
    && ln -s /usr/bin/batcat /usr/local/bin/bat \
    # fd-find is the package name for the 'fd' command.
    && apt-get -y install --no-install-recommends fd-find \
    && ln -s $(which fdfind) /usr/local/bin/fd \
    # Clean up apt lists to keep the image size down.
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# --- UV INSTALLATION (Robust Method) ---
RUN pipx install uv

# --- FONT INSTALLATION ---
# Install Nerd Fonts (MesloLGM) by cloning the repository.
# This method is more robust than downloading individual files via curl.
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k-media.git /tmp/p10k-media \
    && mkdir -p /usr/local/share/fonts/meslolgm \
    && mv /tmp/p10k-media/*.ttf /usr/local/share/fonts/meslolgm/ \
    && rm -rf /tmp/p10k-media \
    && fc-cache -f -v

# --- CONSOLIDATED USER AND PERMISSIONS SETUP ---
# This single RUN command handles all user creation, shell setup, and sudo configuration.
# This makes the user setup process atomic and easier to understand.
RUN if [ "$USERNAME" != "ayondev" ]; then \
    # Create a new group and user with a specific UID/GID.
    # The --shell flag sets the default shell to zsh upon creation.
    # The -m flag creates the home directory with the correct permissions.
    groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell /bin/zsh \
    # Set up passwordless sudo for the new user.
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME; \
    else \
    # If the user is the default 'ayondev' user, just change their shell to zsh.
    chsh -s /usr/bin/zsh ayondev; \
    fi

# Switch to the non-root user. All subsequent commands will run as this user.
USER $USERNAME
