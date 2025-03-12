#!/bin/bash
set -e

SW=" \
  bat\
  base-devel\
  bottom\
  dust\
  eza\
  fish\
  flatpak\
  fzf\
  git\
  interception-tools\
    interception-dual-function-keys\
  jq\
  man-db\
  neovim\
  os-prober\
  pacman-contrib\
  rustup\
  starship\
  yq\
  zoxide\
  "

if [[ $DISPLAY != "" ]]; then
  SW="$SW \
    alacritty\
    bluez\
      bluez-utils\
      blueman\
    cliphist\
    code\
    discord\
    firefox\
    libappindicator-gtk3\ # ??
    noto-fonts\
    noto-fonts-emoji\
    noto-fonts-extra\
    pavucontrol\
      pipewire-pulse\
    rofi-wayland\
      wl-clipboard\
    tmux\
    otf-font-awesome\
    ttf-font-awesome\
    ttf-fira-code\
    ttf-fira-mono\
    ttf-fira-sans\
    ttf-firacode-nerd\
    zathura\
    "

  if [[ $DESKTOP_SESSION = hyprland ]]; then
    SW="$SW \
      feh\
      grim\
        slurp\
      hypridle\
      hyprpaper\
      hyprpicker\
      hyprsunset\
      mako\
      nwm-dock-hyprland\
      waybar\
      xdg-desktop-portal-hyprland\
      "
  fi
fi

echo "Updating system"
sudo pacman -Syu

echo 'Installing software'
# shellcheck disable=2086
sudo pacman -Sy --needed $SW

####
# - Image viewer (feh?)
# - network manager
#
# wayland
# paru -S grimblast
# paru -S wlogout
# hdrop
#
# steam + vulkan
# lutris
#
# paru -S xpadneo-dkms
# enable udevmon service
