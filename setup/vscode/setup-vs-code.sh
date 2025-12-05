#!/bin/bash
# This script generates the symlink to settings.json file
# to keep it in sync with the dotfiles.

# Use alias `eve` to generate `install-extensions.sh` file
# `setup-vs-code.sh` script would run this install-extensions.sh script.

# Code for fresh install to backup and symlink settings
# mv ~/Library/Application\ Support/Code/User/settings.json ~/dotfiles/setup/vscode/

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
SETTINGS_SOURCE="$HOME/dotfiles/setup/vscode/settings.json"

# Create VS Code user directory if it doesn't exist
mkdir -p "$VSCODE_USER_DIR"

# Backup existing settings if it's not a symlink
if [ -f "$VSCODE_USER_DIR/settings.json" ] && [ ! -L "$VSCODE_USER_DIR/settings.json" ]; then
    mv "$VSCODE_USER_DIR/settings.json" "$VSCODE_USER_DIR/settings.json.bak"
fi

ln -sf "$SETTINGS_SOURCE" "$VSCODE_USER_DIR/settings.json"

source install-extensions.sh

exit 0
