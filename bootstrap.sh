#!/usr/bin/env bash
set -eu

echo "-- Checking target directory"
DOTFILES="${DOTFILES:=$HOME/.dotfiles}"
if [ -e "$DOTFILES" ]; then
  echo "'$DOTFILES' is already in use."
  echo "Remove it or set \$DOTFILES to a different location"
  exit 1
else
  echo "$DOTFILES"
fi
export DOTFILES

echo
echo "-- Installing requirements"
REQUIRED=""
if command -v sudo >/dev/null 2>&1; then
  SUDO=sudo
  ARGS="-Kf"
else
  SUDO=""
  ARGS="-f"
fi

if ! command -v git >/dev/null 2>&1; then
  REQUIRED="$REQUIRED git"
fi

if ! command -v ansible >/dev/null 2>&1; then
  REQUIRED="$REQUIRED ansible-core"
fi

if command -v apt >/dev/null 2>&1; then
  eval " $SUDO apt-get update"
  eval " $SUDO apt-get install -y --no-install-recommends \
    apt-transport-https $REQUIRED"
elif command -v pacman >/dev/null 2>&1; then
  eval " $SUDO pacman -Sy $REQUIRED"
fi

echo
echo "-- Cloning repository"
git clone https://github.com/x4121/dotfiles "$DOTFILES"

echo
read -p "Do you want to run ansible to apply the playbook? (y/N)" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo
  echo "-- Applying playbook"
  eval " $DOTFILES/roles/binaries/files/dot $ARGS apply"
fi

echo
echo "-- Done"
