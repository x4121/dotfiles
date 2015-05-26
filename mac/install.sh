#!/bin/bash

echo 'Setting up OSX'

brew --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo 'Installing homebrew'
    ruby -e "$(url -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo 'Installing basics'
brew install caskroom/cask/brew-cask
brew install git
brew install tmux
brew install macvim --override-system-vim
brew install zsh
brew cask install iterm2
