#!/bin/bash

if ! [ -z ${I_DEV+x} ]; then
    echo 'Installing node, npm and grunt'
    curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -
    sudo apt-get install -y nodejs
    sudo npm update -g npm
    sudo npm install -g grunt-cli

    echo 'Installing jenv'
    git clone https://github.com/gcuisinier/jenv.git $HOME/.jenv
    mkdir -p $HOME/.config/fish/functions
    ln -s $HOME/.jenv/fish/export.fish $HOME/.config/fish/functions/export.fish
    ln -s $HOME/.jenv/fish/jenv.fish $HOME/.config/fish/functions/jenv.fish

    echo 'Installing rbenv'
    sudo apt-get install -y \
        libreadline-dev libssl-dev >&- 2>&-
    git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
    git clone https://github.com/rbenv/ruby-build.git \
        $HOME/.rbenv/plugins/ruby-build

    echo 'Installing gems'
    sudo gem install gem-shut-the-fuck-up bundler
fi

echo 'Setting fish as default shell'
chsh -s $(grep /fish$ /etc/shells | tail -1)

pushd $HOME/.dotfiles >&- 2>&-

echo 'Initializing submodule(s)'
git submodule update --init --recursive

if [ "$DISPLAY" != "" ]; then
    echo 'Installing rofi-pass'
    git clone https://github.com/carnager/rofi-pass $HOME/rofi-pass_tmp >&- 2>&-
    pushd $HOME/rofi-pass_tmp >&- 2>&-
    sudo make install
    popd >&- 2>&-
    rm -rf $HOME/rofi-pass_tmp

    echo 'Installing nerd-fonts'
    fontUrl="https://github.com/ryanoasis/nerd-fonts/raw/0.9.0/patched-fonts/SourceCodePro"
    mkdir -p $HOME/.local/share/fonts
    pushd $HOME/.local/share/fonts >&- 2>&-
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
    sudo easy_install pip
    sudo pip install powerline-status

    echo 'Install Franz'
    sudo mkdir -p /opt/franz
    sudo wget -O /opt/franz/Franz.tgz \
        https://github.com/meetfranz/franz-app/releases/download/4.0.4/Franz-linux-x64-4.0.4.tgz \
        2>&-
    sudo tar xzf /opt/franz/Franz.tgz -C /opt/franz
    sudo rm /opt/franz/Franz.tgz

    if ! [ -z ${I_DEV+x} ]; then
        sudo easy_install uncommitted
    fi

    echo 'Setting font and color in gnome-terminal (as fallback)'
    profile=$(dconf read /org/gnome/terminal/legacy/profiles:/default | tr -d "'")
    if [ "$profile" = "" ]; then
        profile=$(dconf list /org/gnome/terminal/legacy/profiles:/ | tr -d ":/")
    fi
    dconf write /org/gnome/terminal/legacy/profiles:/:$profile/visible-name "'Default'"
    dconf write /org/gnome/terminal/legacy/profiles:/:$profile/font "'SauceCodePro Nerd Font Medium 12'"
    dconf write /org/gnome/terminal/legacy/profiles:/:$profile/use-system-font "false"

    gnome-terminal-colors-solarized/install.sh -s dark -p Default --skip-dircolors
fi

if [ "$DESKTOP_SESSION" = "gnome" ]; then
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

popd >&- 2>&-

echo 'Installing Vim-Plugins'
vim +PluginInstall +qall
rm -f $HOME/.vim_mru_files

echo 'Making Vim the default editor'
mimeapps=$HOME/.local/share/applications/mimeapps.list
mimehead="[Default Applications]"
if [ ! -f "$mimeapps" ]; then
    rm -rf $mimeapps
    touch $mimeapps
fi
if grep -vq "$mimehead" "$mimeapps"; then
    echo $mimehead > $mimeapps
fi
cat /usr/share/applications/defaults.list \
    | grep gedit\.desktop \
    | sed 's/gedit\.desktop/vim.desktop/' \
    >> $mimeapps
