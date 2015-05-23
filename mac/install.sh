#!/bin/bash

echo 'Setting up OSX'

echo 'Installing homebrew'
ruby -e "$(url -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo 'Installing basics'
brew install git
brew install tmux
brew install macvim --override-system-vim
brew install zsh
