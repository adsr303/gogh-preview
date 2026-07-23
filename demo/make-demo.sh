#!/usr/bin/env bash

set -eu

[[ -n $1 ]] || {
  echo "Usage: $0 <theme>.yml" >&2
  exit 1
}

TARGET_DIR="$(dirname "$(realpath "$0")")"
declare -r TARGET_DIR
declare -r OUTFILE="${TARGET_DIR}/demo.png"

freeze --execute "bash ${TARGET_DIR}/freeze-cmd.sh ${1@K}" --output "$OUTFILE" --window
mogrify -resize 50% "$OUTFILE"
