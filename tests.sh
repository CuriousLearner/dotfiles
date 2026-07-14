#!/bin/bash

set -e
set -o pipefail

ERRORS=()

# SC2317/SC2329: setup_mac.sh dispatches group functions indirectly via
# "${GROUP_FUNCS[$i]}", which shellcheck can't trace (false "unreachable"/"never invoked").
export SHELLCHECK_OPTS="-e SC2086 -e SC2012 -e SC2317 -e SC2329"

# Lint standalone shell scripts only: a file must both look like shell AND have
# a shebang. Sourced config files (.profile, .aliases, ...) have no shebang and
# are not standalone scripts, so they're skipped rather than tripping SC2148.
# (Without the shebang check, Linux `file` flags them as shell and CI fails,
# while macOS `file` does not -- an inconsistency that broke CI after files
# moved into package subdirectories.)
for f in $(find . -type f -not -iwholename '*.git*' | sort -u); do
    if file "$f" | grep --quiet shell && head -n1 "$f" | grep --quiet '^#!'; then
        {
            shellcheck "$f" && echo "[OK]: successfully linted $f"
        } || {
            # add to errors
            ERRORS+=("$f")
        }
    fi
done

# ---------------------------------------------------------------------------
# 2. Syntax-check the zsh-loaded config files. shellcheck can't parse zsh, so
#    these (including the most important file, .zshrc) are otherwise unchecked.
# ---------------------------------------------------------------------------
echo ""
echo "== zsh syntax check =="
zsh_files=(
    zsh/.zshrc zsh/.p10k.zsh
    shell/.aliases shell/.functions shell/.exports shell/.profile
    shell/.extra shell/.osx shell/.linux shell/.bashrc
)
for f in "${zsh_files[@]}"; do
    [ -f "$f" ] || continue
    if zsh -n "$f" 2>/dev/null; then
        echo "[OK]: $f parses"
    else
        echo "[FAIL]: syntax error in $f"
        zsh -n "$f" || true
        ERRORS+=("$f")
    fi
done

# ---------------------------------------------------------------------------
# 3. Dry-run stow into a throwaway HOME to confirm every package links cleanly
#    with no conflicts (catches broken package layout before install.sh does).
# ---------------------------------------------------------------------------
echo ""
echo "== stow dry-run =="
stow_home="$(mktemp -d)"
mkdir -p "$stow_home/.config"
set +e
stow_out=$(stow -n -v --target="$stow_home" --dir="$PWD" \
    shell zsh git vim misc zed ghostty yazi 2>&1)
stow_rc=$?
set -e
rm -rf "$stow_home"
if [ "$stow_rc" -eq 0 ] && ! printf '%s' "$stow_out" | grep -qiE 'conflict|cannot stow|aborted'; then
    echo "[OK]: all packages stow without conflict"
else
    echo "[FAIL]: stow dry-run reported problems:"
    printf '%s\n' "$stow_out"
    ERRORS+=("stow-dry-run")
fi

echo ""
if [ ${#ERRORS[@]} -eq 0 ]; then
    echo "No errors, hooray"
else
    echo "These files failed shellcheck: ${ERRORS[*]}"
    exit 1
fi
