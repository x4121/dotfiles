#!/bin/bash

echo 'Installing dotfiles'

if ! apt --version > /dev/null 2>&-; then
    echo 'Cannot run apt'
    return 1
fi

apt install -y git apt-transport-https > /dev/null 2>&1
git clone https://github.com/x4121/dotfiles "$HOME/.dotfiles"

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

"$HOME/.dotfiles/install/apt.sh"
"$HOME/.dotfiles/install/postinstall.sh"
