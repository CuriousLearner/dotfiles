#!/bin/bash
# Symlinks the tracked Ghostty config into ~/.config/ghostty to keep it in
# sync with the dotfiles.
#
# Code for fresh install to backup and symlink config:
#   mv ~/.config/ghostty/config ~/dotfiles/setup/ghostty/

GHOSTTY_USER_DIR="$HOME/.config/ghostty"
CONFIG_SOURCE="$HOME/dotfiles/setup/ghostty/config"

# Create Ghostty config directory if it doesn't exist
mkdir -p "$GHOSTTY_USER_DIR"

# Backup existing config if it's not a symlink
if [ -f "$GHOSTTY_USER_DIR/config" ] && [ ! -L "$GHOSTTY_USER_DIR/config" ]; then
    mv "$GHOSTTY_USER_DIR/config" "$GHOSTTY_USER_DIR/config.bak"
fi

ln -sf "$CONFIG_SOURCE" "$GHOSTTY_USER_DIR/config"

exit 0
