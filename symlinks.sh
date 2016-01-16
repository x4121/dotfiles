#!/bin/bash

DOTFILES=$HOME/.dotfiles

echo 'creating symlinks'
linkables=$( find $DOTFILES -maxdepth 1 -name "*.symlink" -exec basename {} \; )
for file in $linkables ; do
    target="$HOME/.$( basename $file ".symlink" )"
    echo "creating symlink for $target"
    rm -rf $target >&- 2>&-
    ln -s $DOTFILES/$file $target
done

linkables=$( find symlinks -type f )
for file in $linkables ; do
    target="$HOME/$( echo $file | sed "s/symlinks\///" )"
    echo "creating symlink for $target"
    mkdir -p $( dirname $target )
    rm -rf $target >&- 2>&-
    ln -s $DOTFILES/$file $target
done
