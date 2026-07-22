#!/bin/bash
# Clones the shared claude-config-common repo plus this machine's private
# overlay repo(s), then assembles them into ~/.claude via common/link.sh.
#
# Overlays are separate private repos (claude-config-<name>) so a locked-down
# machine never clones an overlay it must not have. A machine activates exactly
# the overlays it has cloned next to common — which is exactly the ones it has
# access to. No per-machine edit here: clone what you're entitled to and run.
#   git clone git@github.com:CuriousLearner/claude-config-common.git   claude-config-common
#   git clone git@github.com:CuriousLearner/claude-config-personal.git claude-config-personal
# On a work laptop you'd instead clone your own claude-config-<work> overlay.
#
# If common isn't cloned (e.g. someone else's fork), this skips quietly.
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMMON="$DOTFILES_DIR/claude-config-common"

if [ ! -d "$COMMON/.git" ]; then
    echo "claude-config-common not cloned at $COMMON. Skipping (see this script's header)."
    exit 0
fi

# Auto-discover overlays: every cloned claude-config-*/ next to common, except
# common itself (matches sync-plugin-registry.sh's discovery).
present_overlays=()
for ov in "$DOTFILES_DIR"/claude-config-*/; do
    ov="${ov%/}"
    [ "$ov" = "$COMMON" ] && continue
    [ -d "$ov/.git" ] && present_overlays+=("$ov")
done

"$COMMON/link.sh" "$COMMON" "${present_overlays[@]}"

# Plugins are installed (not seeded) at the end of this script: seeding the
# registry JSON is only bookkeeping and can fool `claude plugin install` into
# skipping a fetch, so the CLI install below is the single source of truth. The
# repo's known_marketplaces.json fragments still declare the marketplace sources
# that step reads; common/sync-plugin-registry.sh keeps those fragments current.

# Overlay settings (an overlay's enabledPlugins for its own plugins, or any
# private machine-local setting) deep-merge into ~/.claude/settings.local.json:
# the real, machine-local, never-shared tier Claude merges over the common
# settings.json symlink (enabledPlugins is unioned across both). Kept out of
# common so private enable-state never reaches a machine that must not have it.
# Must stay a real file — Claude skips a symlinked settings.local.json.
local_settings="$HOME/.claude/settings.local.json"
overlay_settings=()
for repo in "${present_overlays[@]}"; do
    [ -f "$repo/settings.json" ] && overlay_settings+=("$repo/settings.json")
done
if [ "${#overlay_settings[@]}" -gt 0 ]; then
    if command -v jq >/dev/null 2>&1; then
        srcs=(); [ -f "$local_settings" ] && srcs+=("$local_settings"); srcs+=("${overlay_settings[@]}")
        merged="$(jq -s 'reduce .[] as $x ({}; . * $x)' "${srcs[@]}")"
        printf '%s\n' "$merged" > "$local_settings"
        echo "--> [MERGE]: $local_settings <- ${#overlay_settings[@]} overlay settings"
    else
        echo "--> [WARN]: jq missing; skipped overlay settings.local.json merge" >&2
    fi
fi

# Finally, install what's declared. The registry seed above is only bookkeeping;
# Claude Code still has to fetch each marketplace + plugin for it to load. Add
# every marketplace declared in common + overlay fragments, then install every
# enabled plugin from the assembled settings. `add`/`install` are idempotent
# no-ops when already present; </dev/null keeps them non-interactive. Skipped if
# the claude CLI is absent (e.g. a locked-down machine).
if command -v claude >/dev/null 2>&1; then
    for repo in "$COMMON" "${present_overlays[@]}"; do
        [ -f "$repo/plugins/known_marketplaces.json" ] || continue
        jq -r '.[].source.repo // empty' "$repo/plugins/known_marketplaces.json" 2>/dev/null
    done | sort -u | while IFS= read -r src; do
        [ -n "$src" ] || continue
        claude plugin marketplace add "$src" </dev/null >/dev/null 2>&1 || true
    done
    settings_files=("$HOME/.claude/settings.json")
    [ -f "$local_settings" ] && settings_files+=("$local_settings")
    jq -rs 'map(.enabledPlugins // {}) | add | to_entries[] | select(.value) | .key' \
        "${settings_files[@]}" 2>/dev/null | sort -u | while IFS= read -r plug; do
        [ -n "$plug" ] || continue
        claude plugin install "$plug" </dev/null >/dev/null 2>&1 || true
    done
    echo "--> [PLUGINS]: added declared marketplaces and installed enabled plugins"
else
    echo "--> [SKIP]: claude CLI not on PATH; declared plugins not installed"
fi
