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
chsh -s $(which zsh)

echo 'Initializing submodule(s)'
git submodule update --init --recursive

echo 'Installing powerline fonts'
sh powerline_fonts/install.sh

sh $platform/post_submodule_init.sh

sh ./symlinks.sh	
