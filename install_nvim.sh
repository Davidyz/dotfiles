#!/bin/bash

# Define the install location
BIN_DIR="$HOME/.local/"
[ ! -d "$BIN_DIR" ] && mkdir -p "$BIN_DIR"

# Fetch the latest nightly release URL for Linux (adjust 'linux64' if necessary for your OS)
RELEASE_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz"

# Download and extract the release
curl -L "$RELEASE_URL" | tar xz -h -C "$BIN_DIR" --strip-components=1

echo 'Neovim nightly installed successfully.'
echo "Ensure that $HOME/.local/bin is in your PATH to use the nvim command."
