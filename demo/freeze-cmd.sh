#!/usr/bin/env bash

set -eu

[[ -n $1 ]] || {
  echo "Usage: $0 <theme>.yml" >&2
  exit 1
}

printf '$ gogh-preview.sh < "%s"\n' "$(basename "$1")"
"$(dirname "$0")"/../gogh-preview.sh <"$1"
echo '$ _'
