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

if [ ${#ERRORS[@]} -eq 0 ]; then
    echo "No errors, hooray"
else
    echo "These files failed shellcheck: ${ERRORS[*]}"
    exit 1
fi
