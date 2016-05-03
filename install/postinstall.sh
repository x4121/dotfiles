#!/bin/bash

if [ "$DISPLAY" != "" ]; then
    echo 'Installing st'
    sudo apt-get install -y\
        libxft-dev\
        libfontconfig1-dev >&- 2>&-
    git clone https://github.com/x4121/st $HOME/st_tmp >&- 2>&-
    pushd $HOME/st_tmp >&- 2>&-
    make && sudo make install
    popd >&- 2>&-
    rm -rf $HOME/st_tmp

    echo 'Installing node, npm and grunt'
    curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -
    sudo apt-get install -y nodejs
    sudo npm update -g npm
    sudo npm install -g grunt-cli
fi

if ! [ -z ${I_DEV+x} ]; then
    echo 'Installing jenv'
    git clone https://github.com/gcuisinier/jenv.git $HOME/.jenv
    mkdir $HOME/.config/fish/functions
    ln -s $HOME/.jenv/fish/export.fish $HOME/.config/fish/functions/export.fish
    ln -s $HOME/.jenv/fish/jenv.fish $HOME/.config/fish/functions/jenv.fish
fi

echo 'Setting fish as default shell'
chsh -s $(grep /fish$ /etc/shells | tail -1)

pushd $HOME/.dotfiles >&- 2>&-

echo 'Initializing submodule(s)'
git submodule update --init --recursive

if [ "$DISPLAY" != "" ]; then
    echo 'Installing qtpass'
    git clone https://github.com/IJHack/qtpass $HOME/qtpass_tmp >&- 2>&-
    pushd $HOME/qtpass_tmp >&- 2>&-
    qmake && make && sudo make install
    popd >&- 2>&-
    rm -rf $HOME/qtpass_tmp

    echo 'Installing pass-server-node'
    pushd $HOME/.dotfiles/node-server-node >&- 2>&-
    npm install
    npm config set pass-server-node:port 8088
    popd >&- 2>&-

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
        sudo easy_install uncommitted
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

echo 'Creating symlinks'
sh ./symlinks.sh >&- 2>&-

popd >&- 2>&-

echo 'Installing Vim-Plugins'
vim +PluginInstall +qall
rm -f $HOME/.vim_mru_files

echo 'Installing Tmux-Plugins'
sh $HOME/.tmux/plugins/tpm/bin/install_plugins
