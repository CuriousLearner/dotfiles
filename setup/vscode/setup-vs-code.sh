# This script generates the symlink to settings.json file
# to keep it in sync with the dotfiles.

# Use alias `eve` to generate `install-extensions.sh` file
# `setup-vs-code.sh` script would run this install-extensions.sh script.

# Code for fresh install to backup and symlink settings
# mv ~/Library/Application\ Support/Code/User/settings.json ~/dotfiles/setup/vscode/

ln -s /Users/$(whoami)/dotfiles/setup/vscode/settings.json /Users/$(whoami)/Library/Application\ Support/Code/User/settings.json

source install-extensions.sh

exit 0
