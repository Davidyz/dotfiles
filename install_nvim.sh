#!/bin/bash
TAG=stable
[ -z $1 ] || TAG=$1
# Define the install location
BIN_DIR="/usr/"
[ ! -d "$BIN_DIR" ] && mkdir -p "$BIN_DIR"

# Fetch the latest nightly release URL for Linux (adjust 'linux64' if necessary for your OS)
RELEASE_URL="https://github.com/neovim/neovim/releases/download/$TAG/nvim-linux64.tar.gz"

# Download and extract the release
curl -L "$RELEASE_URL" | tar xz -h -C "$BIN_DIR" --strip-components=1

echo "Neovim $TAG installed successfully."
