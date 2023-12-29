#!/bin/bash
set -e

echo 'Installing dotfiles'

if ! apt --version >/dev/null 2>&1; then
	echo 'Cannot run apt'
	return 1
fi

sudo apt install -y git apt-transport-https >/dev/null 2>&1
git clone --recursive https://github.com/x4121/dotfiles "$HOME/.dotfiles"

case $(hostname -s) in
kiste) ;&
reisekoffer)
	export I_HOME=1
	export I_DEV=1
	;;
*)
	unset I_HOME
	unset I_DEV
	;;
esac

# shellcheck disable=1090
. "$HOME/.dotfiles/install/apt.sh"
# shellcheck disable=1090
. "$HOME/.dotfiles/install/postinstall.sh"
