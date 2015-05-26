#!/bin/bash

echo 'Setting font and color'
profile=$(dconf read /org/gnome/terminal/legacy/profiles:/default | tr -d "'")
if [ "$profile" = "" ]; then
    profile=$(dconf list /org/gnome/terminal/legacy/profiles:/ | tr -d ":/")
fi
dconf write /org/gnome/terminal/legacy/profiles:/:$profile/visible-name "'Default'"
dconf write /org/gnome/terminal/legacy/profiles:/:$profile/font "'Source Code Pro for Powerline Medium 12'"
dconf write /org/gnome/terminal/legacy/profiles:/:$profile/use-system-font "false"

linux/gnome-terminal-colors-solarized/install.sh -s dark -p Default
