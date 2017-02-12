#!/bin/bash

if ! [[ -z ${I_DEV+x} ]]; then
    echo 'Installing node, npm and grunt'
    curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -
    sudo apt-get install -y nodejs
    sudo npm update -g npm
    sudo npm install -g grunt-cli

    echo 'Installing jenv'
    git clone https://github.com/gcuisinier/jenv.git "$HOME/.jenv"
    mkdir -p "$HOME/.config/fish/functions"
    ln -s "$HOME/.jenv/fish/export.fish" "$HOME/.config/fish/functions/export.fish"
    ln -s "$HOME/.jenv/fish/jenv.fish" "$HOME/.config/fish/functions/jenv.fish"

    echo 'Installing rbenv'
    sudo apt-get install -y \
        libreadline-dev libssl-dev >&- 2>&-
    git clone https://github.com/rbenv/rbenv.git "$HOME/.rbenv"
    git clone https://github.com/rbenv/ruby-build.git \
        "$HOME/.rbenv/plugins/ruby-build"

    echo 'Installing gems'
    sudo gem install gem-shut-the-fuck-up bundler git-amnesia

    echo 'Installing shellcheck'
    cabal update
    cabal install ShellCheck
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

echo 'Setting fish as default shell'
chsh -s "$(grep /fish$ /etc/shells | tail -1)"

pushd "$HOME/.dotfiles" >&- 2>&-

echo 'Initializing submodule(s)'
git submodule update --init --recursive

if [[ $DISPLAY != "" ]]; then
    echo 'Installing pip'
    sudo easy_install pip

    echo 'Installing stjerm'
    tmp="$(mktemp -d)"
    git clone https://github.com/stjerm/stjerm "$tmp" >&- 2>&-
    pushd "$tmp" >&- 2>&-
    ./autogen.sh
    ./configure
    make
    sudo make install
    popd >&- 2>&-
    rm -rf "$tmp"

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

    if ! [[ -z ${I_DEV+x} ]]; then
        sudo easy_install uncommitted
    fi

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
    SHELL_VER="3.18"
    gnomeshell_install="$HOME/.dotfiles/bin.symlink/gnomeshell-extension-manage \
        --install --version $SHELL_VER --extension-id"
    # media player indicator
    $gnomeshell_install 55
    # dash to dock
    $gnomeshell_install 307
    # hide legacy tray
    $gnomeshell_install 967
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
sh ./symlinks.sh >&- 2>&-

echo 'Installing fzf'
git clone https://github.com/junegunn/fzf "$HOME/.fzf"
"$HOME/.fzf/install --all"

popd >&- 2>&-

echo 'Installing Vim-Plugins'
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
rm -f "$HOME/.vim_mru_files"

echo 'Installing tmux plugins'
"$HOME/.tmux/plugins/tpm/bin/install_plugins"
PRUNE="$HOME/.tmux/resurrect && ls -A1t | tail -n +12 | xargs -r rm"
CRON="0 * * * * cd $PRUNE"
crontab -l 2>/dev/null \
    | fgrep -i -v "$PRUNE" \
    | { cat; echo "$CRON"; } \
    | crontab -

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
