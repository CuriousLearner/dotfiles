#!/usr/bin/env bash

# Find files with Windows line endings (and convert them to Unix in force mode)
#
# Usage:
#   crlf [file] [--force]

force=

function _crlf_file() {
  if grep -q $'\x0D' "$1"; then
    echo "$1"
    if [ "$2" ]; then
      if command -v dos2unix &> /dev/null; then
        dos2unix "$1"
      else
        # Fallback: use sed if dos2unix is not installed
        sed -i'' -e 's/\r$//' "$1"
      fi
    fi
  fi
}

# Single file
if [ "$1" != "" ] && [ "$1" != "--force" ]; then
  [ "$2" == "--force" ] && force=1 || force=0
  _crlf_file "$1" $force
  exit 0
fi

# All files
[ "$1" == "--force" ] && force=1 || force=0
for file in $(find . -type f -not -path "*/.git/*" -not -path "*/node_modules/*" -print0 | xargs -0 file | grep ASCII | cut -d: -f1); do
  _crlf_file "$file" $force
done
