#!/usr/bin/env bash
set -euo pipefail

selection="$(slurp)" || exit 0
[[ -n "$selection" ]] || exit 0
grim -g "$selection" - | wl-copy --type image/png
