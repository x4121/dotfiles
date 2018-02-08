#!/bin/bash

DOTFILES=$HOME/.dotfiles

pushd "$DOTFILES" >&- 2>&-

echo 'creating symlinks'
linkables=$( find ./symlinks -maxdepth 1 -name "*.symlink" -exec basename {} \; )
for file in $linkables; do
    target="$HOME/.$( basename "$file" ".symlink" )"
    echo "creating symlink for $target"
    rm -rf "$target" >&- 2>&-
    ln -s "$DOTFILES/symlinks/$file" "$target"
done

linkables=$( find symlinks/{global,"$USER"} -type f -o -type l )
for file in $linkables; do
    target="$HOME/$(echo "$file" | sed 's/symlinks\/[^\/]*\///')"
    echo "creating symlink for $target"
    mkdir -p "$( dirname "$target" )"
    rm -rf "$target" >&- 2>&-
    ln -s "$DOTFILES/$file" "$target"
done

popd >&- 2>&-
