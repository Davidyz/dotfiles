#!/bin/bash
URL=https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
[ -z "$1" ] || URL=$1
# Define the install location
BIN_DIR="/usr/"
[ ! -d "$BIN_DIR" ] && mkdir -p "$BIN_DIR"

# Download and extract the release
curl -L "$URL" | tar xz -h -C "$BIN_DIR" --strip-components=1

echo "Neovim $URL installed successfully."
