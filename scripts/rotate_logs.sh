#!/usr/bin/env bash
# Keep log files small. Any file over MAX_MB keeps its last KEEP_MB in "<file>.1"
# and is then emptied. It copies and truncates in place (instead of renaming) so
# a running service that holds the file open, like a brew service, keeps logging.
# Usage: rotate_logs.sh <logfile>...
set -euo pipefail

MAX_MB="${MAX_MB:-20}"
KEEP_MB="${KEEP_MB:-2}"

for file in "$@"; do
  [[ -f "$file" ]] || continue
  size=$(wc -c <"$file")
  if ((size > MAX_MB * 1024 * 1024)); then
    tail -c $((KEEP_MB * 1024 * 1024)) "$file" >"$file.1"
    : >"$file"
    echo "rotated $file ($((size / 1024 / 1024)) MB -> $KEEP_MB MB kept in $file.1)"
  fi
done
