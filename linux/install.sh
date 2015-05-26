#!/bin/bash

echo 'Setting up Linux'
apt > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo 'Cannot run apt'
    return -1
fi

echo 'Updating system'
sudo apt-get update > /dev/null

echo 'Installing basics'
sudo apt-get install -y ctags git htop tmux vim zsh

if [ ! -d "$HOME/.fonts" ]; then
    mkdir $HOME/.fonts
fi

echo 'Setting font and color'
profile=$(dconf read /org/gnome/terminal/legacy/profiles:/default | tr -d "'")
dconf write /org/gnome/terminal/legacy/profiles:/:$profile/visible-name "'Default'"
dconf write /org/gnome/terminal/legacy/profiles:/:$profile/font "'Source Code Pro for Powerline Medium 12'"

linux/gnome-terminal-colors-solarized/install.sh -s dark -p Default
