#!/bin/bash

echo 'Installing dotfiles'

apt > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo 'Cannot run apt'
    return -1
fi

sudo apt-get install -y git > /dev/null 2>&1
git clone https://github.com/x4121/dotfiles $HOME/.dotfiles

case $(hostname -s) in
    kiste)
        export I_HOME=1
        export I_DEV=1
        ;;
    *)
        unset I_HOME
        unset I_DEV
        ;;
esac

$HOME/.dotfiles/install/apt.sh
$HOME/.dotfiles/install/postinstall.sh
