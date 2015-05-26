#!/bin/bash

echo 'Installing dotfiles'

echo 'Detecting OS'
if [ "$(uname)" == "Darwin" ]; then
    platform='mac'
elif [ "$(uname)" == "Linux" ]; then
    platform='linux'
fi

sh $platform/install.sh

echo 'Setting zsh as default shell'
sudo chsh -s $(which zsh) $USER

echo 'Initializing submodule(s)'
git submodule update --init --recursive

echo 'Installing powerline fonts'
source powerline_fonts/install.sh

sh $platform/post_submodule_init.sh

sh ./symlinks.sh	
