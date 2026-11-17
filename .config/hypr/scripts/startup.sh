#!/usr/bin/env bash
set -u

start_once() {
    local process_name="$1"
    shift
    if command -v "$1" >/dev/null 2>&1 && ! pgrep -x "$process_name" >/dev/null 2>&1; then
        "$@" >/dev/null 2>&1 &
    fi
}

start_once waybar waybar
start_once swaync swaync
start_once nm-applet nm-applet
start_once blueman-applet blueman-applet
start_once hypridle hypridle

if command -v hyprpolkitagent >/dev/null 2>&1; then
    systemctl --user start hyprpolkitagent.service >/dev/null 2>&1 || start_once hyprpolkitagent hyprpolkitagent
elif command -v polkit-gnome-authentication-agent-1 >/dev/null 2>&1; then
    start_once polkit-gnome-authentication-agent-1 polkit-gnome-authentication-agent-1
fi

script_dir="$(cd -- "$(dirname -- "$0")" && pwd)"
repo_dir="$(cd -- "$script_dir/../../.." && pwd)"
wallpaper="$repo_dir/wallpapers/37.jpg"
wallpaper_link="$HOME/.config/hypr/current_wallpaper"

if [[ -f "$wallpaper" ]]; then
    ln -sfn "$wallpaper" "$wallpaper_link"
    if command -v awww-daemon >/dev/null 2>&1 && command -v awww >/dev/null 2>&1; then
        start_once awww-daemon awww-daemon
        sleep 1
        awww img "$wallpaper" >/dev/null 2>&1 || true
    elif command -v swww-daemon >/dev/null 2>&1 && command -v swww >/dev/null 2>&1; then
        start_once swww-daemon swww-daemon
        sleep 1
        swww img "$wallpaper" --transition-type fade --transition-duration 1 >/dev/null 2>&1 || true
    fi
fi
