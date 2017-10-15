#!/usr/bin/env bash

# Find files with Windows line endings (and convert them to Unix in force mode)
#
# Usage:
#   crlf [file] [--force]

local force=

function _crlf_file() {
  grep -q $'\x0D' "$1" && echo "$1" && [ $2 ] && dos2unix "$1"
}

# Single file
if [ "$1" != "" ] && [ "$1" != "--force" ]; then
  [ "$2" == "--force" ] && force=1 || force=0
  _crlf_file $1 $force
  return
fi

# All files
[ "$1" == "--force" ] && force=1 || force=0
for file in $(find . -type f -not -path "*/.git/*" -not -path "*/node_modules/*" | xargs file | grep ASCII | cut -d: -f1); do
  _crlf_file $file $force
done
