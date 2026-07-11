#!/bin/bash
# Symlinks a private, separately-cloned claude-config repo into ~/.claude.
#
# claude-config holds Claude Code skills, CLAUDE.md, settings.json, and
# mcp.json that are too work-specific for this public repo. It's deliberately
# NOT a git submodule: it's edited and pushed independently and continuously,
# with no need to pin dotfiles to a specific claude-config commit, so a
# submodule would only add ceremony (bump-the-pointer commits, --recursive,
# detached HEAD) for no real benefit — and it would put its private URL in
# this repo's public history besides. Clone it yourself into
# dotfiles/claude-config before running this script:
#   git clone <your-private-claude-config-repo-url> claude-config
#
# If it hasn't been cloned (e.g. on someone else's fork of dotfiles), this
# script skips quietly instead of failing setup for everyone else.

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_CONFIG_DIR="$DOTFILES_DIR/claude-config"
CLAUDE_DIR="$HOME/.claude"

if [ ! -d "$CLAUDE_CONFIG_DIR/.git" ]; then
    echo "claude-config not cloned at $CLAUDE_CONFIG_DIR. Skipping (see this script's header)."
    exit 0
fi

if [ ! -e "$HOME/claude-config" ]; then
    ln -s "$CLAUDE_CONFIG_DIR" "$HOME/claude-config"
    echo "--> [LINK]: $HOME/claude-config -> $CLAUDE_CONFIG_DIR"
fi

mkdir -p "$CLAUDE_DIR" "$CLAUDE_DIR/plugins"

# plugins/installed_plugins.json and known_marketplaces.json are NOT symlinked:
# Claude Code's plugin manager writes them via write-temp-then-rename, which
# would silently replace the symlink with a fresh regular file the first time
# a plugin is installed/updated. See claude-config/sync-plugin-registry.sh.
for f in skills CLAUDE.md settings.json mcp.json plugins/config.json; do
    target="$CLAUDE_DIR/$f"
    link_source="$HOME/claude-config/$f"

    if [ -L "$target" ]; then
        continue
    fi

    if [ -e "$target" ]; then
        TIME=$(date +%s)
        echo "--> [BACKUP]: $target -> $target.$TIME.bak"
        mv "$target" "$target.$TIME.bak"
    fi

    ln -s "$link_source" "$target"
    echo "--> [LINK]: $target -> $link_source"
done

for f in installed_plugins.json known_marketplaces.json; do
    target="$CLAUDE_DIR/plugins/$f"
    src="$HOME/claude-config/plugins/$f"
    if [ ! -e "$target" ] && [ -e "$src" ]; then
        cp "$src" "$target"
        echo "--> [COPY]: $target <- $src (one-time seed, not a live link)"
    fi
done
