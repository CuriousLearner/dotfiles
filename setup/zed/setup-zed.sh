#!/bin/bash
# This script generates the symlink to settings.json file
# to keep it in sync with the dotfiles.

# Code for fresh install to backup and symlink settings
# mv ~/.config/zed/settings.json ~/dotfiles/setup/zed/

ZED_USER_DIR="$HOME/.config/zed"
SETTINGS_SOURCE="$HOME/dotfiles/setup/zed/settings.json"

# Create Zed config directory if it doesn't exist
mkdir -p "$ZED_USER_DIR"

# Backup existing settings if it's not a symlink
if [ -f "$ZED_USER_DIR/settings.json" ] && [ ! -L "$ZED_USER_DIR/settings.json" ]; then
    mv "$ZED_USER_DIR/settings.json" "$ZED_USER_DIR/settings.json.bak"
fi

ln -sf "$SETTINGS_SOURCE" "$ZED_USER_DIR/settings.json"

exit 0
