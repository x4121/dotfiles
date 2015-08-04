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
sudo apt-get install -y exuberant-ctags git htop tmux vim zsh

if [ ! -d "$HOME/.fonts" ]; then
    mkdir $HOME/.fonts
fi
