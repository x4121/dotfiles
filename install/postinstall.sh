#!/bin/bash

if [ "$DISPLAY" != "" ]; then
    echo 'Installing st'
    sudo apt-get install -y\
        libxft-dev\
        libfontconfig1-dev\
        libxext-dev >&- 2>&-
    git clone https://github.com/x4121/st $HOME/st_tmp >&- 2>&-
    pushd $HOME/st_tmp >&- 2>&-
    make && sudo make install
    popd >&- 2>&-
    rm -rf $HOME/st_tmp

    echo 'Installing keepassx'
    sudo apt-get install -y\
        cmake\
        libqt4-dev\
        libgcrypt20-dev\
        libmicrohttpd-dev\
        libqjson-dev >&- 2>&-
    git clone https://github.com/x4121/keepassx $HOME/keepassx_tmp >&- 2>&-
    mkdir $HOME/keepassx_tmp/build
    pushd $HOME/keepassx_tmp/build >&- 2>&-
    cmake .. && make -j4 && sudo make install
    popd >&- 2>&-
    rm -rf $HOME/keepassx_tmp

    #echo 'Installing mutt'
    #sudo apt-get install -y autoconf libslang2-dev libiconv-hook-dev libssl-dev >&- 2>&-
    #git clone https://github.com/karelzak/mutt-kz $HOME/mutt-kz_tmp >&- 2>&-
    #pushd $HOME/mutt-kz_tmp >&- 2>&-
    #./prepare --with-slang --enable-imap --enable-pop --with-ssl
    #make && sudo make install
    #popd >&- 2>&-
    #rm -rf $HOME/mutt-kz_tmp

    fish --version >&- 2>&-
    if [ $? -eq 0 ]; then
        curl -L github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish
        omf theme agnoster
        omf install apt
    fi
fi

if ! [ -z ${I_DEV+x} ]; then
    echo 'Installing jenv'
    git clone https://github.com/gcuisinier/jenv.git $HOME/.jenv
fi

echo 'Setting fish as default shell'
chsh -s $(grep /fish$ /etc/shells | tail -1)

pushd $HOME/.dotfiles >&- 2>&-

echo 'Initializing submodule(s)'
git submodule update --init --recursive

if [ "$DISPLAY" != "" ]; then
    echo 'Installing powerline fonts'
    mkdir -p $HOME/.fonts
    source powerline_fonts/install.sh

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
