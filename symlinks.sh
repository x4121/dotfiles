#!/bin/bash

DOTFILES=$HOME/.dotfiles

echo 'creating symlinks'
linkables=$( find . -maxdepth 2 -name "*.symlink" -exec basename {} \; )
for file in $linkables ; do
    target="$HOME/.$( basename $file ".symlink" )"
    echo "creating symlink for $file"
    ln -s $DOTFILES/$file $target
done
