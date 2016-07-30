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

    echo 'Installing powerline fonts'
    mkdir -p $HOME/.fonts
    source powerline_fonts/install.sh

    echo 'Installing Powerline'
    sudo easy_install3 pip
    sudo pip install powerline-status

    if ! [ -z ${I_DEV+x} ]; then
        sudo easy_install3 uncommitted
    fi

    echo 'Setting font and color in gnome-terminal (as fallback)'
    profile=$(dconf read /org/gnome/terminal/legacy/profiles:/default | tr -d "'")
    if [ "$profile" = "" ]; then
        profile=$(dconf list /org/gnome/terminal/legacy/profiles:/ | tr -d ":/")
    fi
    dconf write /org/gnome/terminal/legacy/profiles:/:$profile/visible-name "'Default'"
    dconf write /org/gnome/terminal/legacy/profiles:/:$profile/font "'Source Code Pro for Powerline Medium 12'"
    dconf write /org/gnome/terminal/legacy/profiles:/:$profile/use-system-font "false"

    gnome-terminal-colors-solarized/install.sh -s dark -p Default
fi

if [ "$DESKTOP_SESSION" = "gnome" ]; then
    SHELL_VER="3.18"
    gnomeshell-install="$HOME/.dotfiles/bin.symlink/gnomeshell-extension-manage \
        --install --version $SHELL_VER --extension-id"
    # media player indicator
    $gnomeshell-install 55
    # dash to dock
    $gnomeshell-install 307
    # hide legacy tray
    $gnomeshell-install 967
    # topicons plus
    $gnomeshell-install 1031
    # no topleft hot corner
    $gnomeshell-install 118
    # notification alert
    $gnomeshell-install 258
    # openweather
    $gnomeshell-install 750

fi

echo 'Creating symlinks'
sh ./symlinks.sh >&- 2>&-

popd >&- 2>&-

echo 'Installing Vim-Plugins'
vim +PluginInstall +qall
rm -f $HOME/.vim_mru_files
