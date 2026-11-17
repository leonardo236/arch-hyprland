#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "$0")" && pwd)"
repo_dir="$(cd -- "$script_dir/../../.." && pwd)"
wallpaper_dir="$repo_dir/wallpapers"
symlink_path="$HOME/.config/hypr/current_wallpaper"

if ! command -v rofi >/dev/null 2>&1; then
    printf 'Install rofi to choose a wallpaper.\n' >&2
    exit 1
fi

selected_wall="$(
    find "$wallpaper_dir" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        -printf '%f\n' | sort -f | rofi -dmenu -i -p "Wallpaper" || true
)"
[[ -n "$selected_wall" ]] || exit 0
selected_path="$wallpaper_dir/$selected_wall"
[[ -f "$selected_path" ]] || exit 1

matugen image "$selected_path"
ln -sfn "$selected_path" "$symlink_path"

if command -v awww >/dev/null 2>&1 && pgrep -x awww-daemon >/dev/null 2>&1; then
    awww img "$selected_path"
elif command -v swww >/dev/null 2>&1 && pgrep -x swww-daemon >/dev/null 2>&1; then
    swww img "$selected_path" --transition-type fade --transition-duration 1
fi

