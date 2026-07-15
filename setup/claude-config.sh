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

# Plugin registry: MERGE common + each present overlay's fragment, then expand
# the $HOME placeholder. Overlays ship their own marketplaces/plugins so a
# machine is self-contained from its clones alone (the locked-down machine
# never clones an overlay, so never sees its plugins). Seeded as one-time
# copies (not symlinks) because Claude Code rewrites these via
# write-temp-then-rename. Re-snapshot with common/sync-plugin-registry.sh.
mkdir -p "$HOME/.claude/plugins"
seed_registry() {  # seed_registry <filename> <jq-merge-expr>
    local f="$1" merge="$2" target="$HOME/.claude/plugins/$1"
    [ -e "$target" ] && return 0   # one-time seed; Claude owns the live file
    local repo; local -a srcs=()
    for repo in "$COMMON" "${present_overlays[@]}"; do
        [ -f "$repo/plugins/$f" ] && srcs+=("$repo/plugins/$f")
    done
    [ "${#srcs[@]}" -gt 0 ] || return 0
    if command -v jq >/dev/null 2>&1; then
        jq -s "$merge" "${srcs[@]}" | sed "s#[$]HOME#$HOME#g" > "$target"
    else
        [ "${#srcs[@]}" -eq 1 ] || echo "--> [WARN]: jq missing; overlay plugins not merged into $f" >&2
        sed "s#[$]HOME#$HOME#g" "${srcs[0]}" > "$target"
    fi
    echo "--> [SEED]: $target (merged ${#srcs[@]} source(s), expanded \$HOME, one-time)"
}
seed_registry installed_plugins.json '{version: (map(.version) | last // 2), plugins: (map(.plugins) | add)}'
seed_registry known_marketplaces.json 'add'

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
