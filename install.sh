#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_ROOT="$HOME/.local/state/arch-hyprland-backups/$(date +%Y%m%d-%H%M%S)"

if [[ "$(id -u)" -eq 0 ]]; then
    printf 'Run this installer as your normal user, not root.\n' >&2
    exit 1
fi

if [[ ! -r /etc/os-release ]]; then
    printf 'Cannot identify this Linux distribution.\n' >&2
    exit 1
fi

. /etc/os-release
distro_ids="$ID ${ID_LIKE:-}"
case "$distro_ids" in
    *arch*|*cachyos*)
        ;;
    *)
        printf 'This installer supports Arch Linux and CachyOS only (detected: %s).\n' "$ID" >&2
        exit 1
        ;;
esac

if ! command -v pacman >/dev/null 2>&1 || ! command -v sudo >/dev/null 2>&1; then
    printf 'pacman and sudo are required.\n' >&2
    exit 1
fi

required_packages=(
    hyprland waybar kitty rofi cava matugen
    pipewire pipewire-pulse wireplumber
    xdg-desktop-portal xdg-desktop-portal-hyprland
    grim slurp wl-clipboard swaync
)

optional_candidates=(
    hypridle hyprlock hyprpolkitagent polkit-gnome wlogout swww awww nautilus yazi hyprpicker
    network-manager-applet blueman brightnessctl playerctl pavucontrol
    pamixer fastfetch xorg-xwayland ttf-jetbrains-mono-nerd
)
optional_packages=()
for package in "${optional_candidates[@]}"; do
    if pacman -Si "$package" >/dev/null 2>&1 || pacman -Qi "$package" >/dev/null 2>&1; then
        optional_packages+=("$package")
    fi
done

printf 'Installing required packages and available optional tools. Pacman may upgrade the system as part of -Syu.\n'
sudo pacman -Syu --needed "${required_packages[@]}" "${optional_packages[@]}"

mkdir -p "$CONFIG_DIR"
mkdir -p "$BACKUP_ROOT"

link_config() {
    local name="$1"
    local source="$DOTFILES_DIR/.config/$name"
    local destination="$CONFIG_DIR/$name"
    local resolved_source
    local resolved_destination

    [[ -e "$source" ]] || return 0
    resolved_source="$(readlink -f "$source")"
    if [[ -L "$destination" ]]; then
        resolved_destination="$(readlink -f "$destination" 2>/dev/null || true)"
        [[ "$resolved_destination" == "$resolved_source" ]] && return 0
    fi

    if [[ -e "$destination" || -L "$destination" ]]; then
        mkdir -p "$BACKUP_ROOT"
        mv -- "$destination" "$BACKUP_ROOT/$name"
        printf 'Backed up existing %s config to %s\n' "$name" "$BACKUP_ROOT/$name"
    fi
    ln -s "$source" "$destination"
}

for name in cava fastfetch hypr kitty matugen rofi swaync waybar wlogout; do
    link_config "$name"
done

if [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" && -e "$DOTFILES_DIR/.zshrc" ]]; then
    if [[ -e "$HOME/.zshrc" || -L "$HOME/.zshrc" ]]; then
        mv -- "$HOME/.zshrc" "$BACKUP_ROOT/.zshrc"
        printf 'Backed up existing .zshrc to %s/.zshrc\n' "$BACKUP_ROOT"
    fi
    ln -sfn "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
fi

chmod +x "$DOTFILES_DIR/.config/hypr/scripts/"*.sh

printf '\nInstalled from %s\n' "$DOTFILES_DIR"
printf 'Existing configs, if any, were backed up under %s\n' "$BACKUP_ROOT"
printf 'Log out, select the Hyprland session, then log in again.\n'
printf 'Shortcuts: Super+Enter terminal, Super+Shift+C Cava, Super+D apps, Super+W wallpaper.\n'
