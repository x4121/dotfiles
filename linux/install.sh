#!/bin/bash

echo 'Setting up Linux'
apt > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo 'Cannot run apt'
    return -1
fi

echo 'Updating system'
sudo apt-get update
sudo apt-get -y upgrade

echo 'Installing basics'
sudo apt-get install -y ctags git htop tmux vim zsh

if [ ! -d "$HOME/.fonts" ]; then
    mkdir $HOME/.fonts
fi

gnome-terminal-colors-solarized/install.sh -s dark -p Default
