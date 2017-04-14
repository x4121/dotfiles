#!/bin/bash

if ! [[ -z ${I_DEV+x} ]]; then
    echo 'Installing jenv'
    git clone https://github.com/gcuisinier/jenv.git \
        "$HOME/.jenv" >&- 2>&-
    mkdir -p "$HOME/.config/fish/functions"
    ln -s "$HOME/.jenv/fish/export.fish" \
        "$HOME/.config/fish/functions/export.fish" >&- 2>&-
    ln -s "$HOME/.jenv/fish/jenv.fish" \
        "$HOME/.config/fish/functions/jenv.fish" &>- 2>&-

    echo 'Installing gems'
    sudo gem install \
        gem-shut-the-fuck-up bundler git-amnesia git-rc rubocop >&- 2>&-
fi

echo 'Installing git-lfs'
tmp="$(mktemp -d)"
pushd "$tmp" >&- 2>&-
curl -fLo "lfs.tgz" \
    "https://github.com/git-lfs/git-lfs/releases/download/v1.5.5/git-lfs-linux-amd64-1.5.5.tar.gz" \
    2>&-
tar xzf "lfs.tgz" --strip-components 1
sudo mkdir -p /usr/local/bin
sudo install git-lfs /usr/local/bin/git-lfs
git lfs install
popd >&- 2>&-
rm -rf "$tmp"

pushd "$HOME/.dotfiles" >&- 2>&-

if [[ $DISPLAY != "" ]]; then
    echo 'Installing pip'
    sudo easy_install pip >&- 2>&-

    echo 'Installing rofi-pass'
    tmp="$(mktemp -d)"
    git clone https://github.com/carnager/rofi-pass "$tmp" >&- 2>&-
    pushd "$tmp" >&- 2>&-
    sudo make install
    popd >&- 2>&-
    rm -rf "$tmp"

    echo 'Installing nerd-fonts'
    fontUrl="https://github.com/ryanoasis/nerd-fonts/raw/0.9.0/patched-fonts/SourceCodePro"
    mkdir -p "$HOME/.local/share/fonts"
    pushd "$HOME/.local/share/fonts" >&- 2>&-
    OLDIFS=$IFS; IFS=','
    for i in Medium,%20Medium Regular,"" Bold,%20Bold; do
        set -- $i
        curl -fLo "SauceCodeProNerd $1.ttf" \
            "$fontUrl/$1/complete/Sauce%20Code%20Pro$2%20Nerd%20Font%20Complete%20Mono.ttf" \
            2>&-
    done
    IFS=$OLDIFS
    popd >&- 2>&-

    echo 'Installing Powerline'
    sudo pip install powerline-status

    echo 'Installing mutt dependencies'
    sudo pip install mutt_ics vobject
    sudo pip install gcalcli

    echo 'Install Franz'
    sudo mkdir -p /opt/franz
    sudo wget -O /opt/franz/Franz.tgz \
        https://github.com/meetfranz/franz-app/releases/download/4.0.4/Franz-linux-x64-4.0.4.tgz \
        2>&-
    sudo tar xzf /opt/franz/Franz.tgz -C /opt/franz
    sudo rm /opt/franz/Franz.tgz

    echo 'Setting font and color in gnome-terminal (as fallback)'
    profile=$(dconf read /org/gnome/terminal/legacy/profiles:/default | tr -d "'")
    if [[ $profile = "" ]]; then
        profile=$(dconf list /org/gnome/terminal/legacy/profiles:/ | tr -d ":/")
    fi
    dconf write "/org/gnome/terminal/legacy/profiles:/:$profile/visible-name" "'Default'"
    dconf write "/org/gnome/terminal/legacy/profiles:/:$profile/font" "'SauceCodePro Nerd Font Medium 12'"
    dconf write "/org/gnome/terminal/legacy/profiles:/:$profile/use-system-font" "false"

    gnome-terminal-colors-solarized/install.sh -s dark -p Default --skip-dircolors
fi

if [[ $DESKTOP_SESSION = gnome ]]; then
    gnomeshell_install="$HOME/.dotfiles/bin.symlink/gnomeshell-extension-manage \
        --install --extension-id"
    # media player indicator
    $gnomeshell_install 55
    # dash to dock
    $gnomeshell_install 307
    # topicons plus
    $gnomeshell_install 1031
    # no topleft hot corner
    $gnomeshell_install 118
    # notification alert
    #$gnomeshell_install 258
    # openweather
    $gnomeshell_install 750

fi

echo 'Creating symlinks'
bash ./symlinks.sh >&- 2>&-

popd >&- 2>&-

echo 'Installing Vim-Plugins'
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

echo 'Setting fish as default shell'
sudo chsh -s "$(grep /fish$ /etc/shells | tail -1)" "$USER"

echo 'Installing tmux plugins'
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

echo 'Setting up mail sync'
mkdir "$HOME/Mail"
SYNC="users | grep $USER >/dev/null && $HOME/.bin/mailsync.sh"
CRON="*/15 * * * * $SYNC"
crontab -l 2>/dev/null \
    | fgrep -i -v "$SYNC" \
    | { cat; echo "$CRON"; } \
    | crontab -

echo 'Making Vim the default editor'
mimeapps=$HOME/.local/share/applications/mimeapps.list
mimehead="[Default Applications]"
if [[ ! -f $mimeapps ]]; then
    rm -rf "$mimeapps"
    touch "$mimeapps"
fi
if grep -vq "$mimehead" "$mimeapps"; then
    echo "$mimehead" > "$mimeapps"
fi
grep gedit\.desktop "/usr/share/applications/defaults.list" \
    | sed 's/gedit\.desktop/vim.desktop/' \
    >> "$mimeapps"
