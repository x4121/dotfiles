#!/bin/bash

DOTFILES=$HOME/.dotfiles

echo 'creating symlinks'
linkables=$( find $DOTFILES -maxdepth 2 -name "*.symlink" -exec basename {} \; )
for file in $linkables ; do
    target="$HOME/.$( basename $file ".symlink" )"
    echo "creating symlink for $target"
    rm -rf $target > /dev/null 2>&1
    ln -s $DOTFILES/$file $target
done
