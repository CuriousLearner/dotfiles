#!/usr/bin/env bash
#
# Symlink all dotfile packages into place with GNU stow.
# Replaces the old bootstrap.sh + per-tool setup scripts: each top-level
# directory here is a stow "package" whose contents mirror where they land
# under $HOME (e.g. zsh/.zshrc -> ~/.zshrc, zed/.config/zed/settings.json ->
# ~/.config/zed/settings.json).
#
# Requires: stow (brew install stow, included in setup/setup_mac.sh).

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES"

if ! command -v stow >/dev/null 2>&1; then
    echo "stow not found. Install it first: brew install stow" >&2
    exit 1
fi

PACKAGES=(shell zsh git vim misc zed ghostty yazi)

# Ensure ~/.config exists so stow folds package files into it instead of
# trying to symlink the whole directory.
mkdir -p "$HOME/.config"

echo "==> Stowing packages into \$HOME: ${PACKAGES[*]}"
stow --restow "${PACKAGES[@]}"

echo "==> Done."
echo "    Binaries run from $DOTFILES/bin (already on PATH via .exports)."
echo "    VS Code and Claude config still use their own setup scripts."
