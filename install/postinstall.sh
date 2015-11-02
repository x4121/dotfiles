#!/bin/bash

fish --version > /dev/null 2>&1
if [ $? -eq 0 ]; then
    curl -L github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish
    omf theme agnoster
    omf install apt
fi

if [ "$DISPLAY" != "" ]; then
    echo 'Installing st'
    sudo apt-get install -y\
        libxft-dev\
        libfontconfig1-dev\
        libxext-dev > /dev/null
    git clone https://github.com/x4121/st $HOME/st_tmp > /dev/null
    pushd $HOME/st_tmp > /dev/null
    make && sudo make install
    popd > /dev/null
    rm -rf $HOME/st_tmp

    echo 'Installing keepassx'
    sudo apt-get install -y\
        cmake\
        libqt4-dev\
        libgcrypt20-dev\
        libmicrohttpd-dev\
        libqjson-dev > /dev/null
    git clone https://github.com/x4121/keepassx $HOME/keepassx_tmp > /dev/null
    mkdir $HOME/keepassx_tmp/build
    pushd $HOME/keepassx_tmp/build > /dev/null
    cmake .. && make -j4 && sudo make install
    popd > /dev/null
    rm -rf $HOME/keepassx_tmp

    #echo 'Installing mutt'
    #sudo apt-get install -y autoconf libslang2-dev libiconv-hook-dev libssl-dev > /dev/null
    #git clone https://github.com/karelzak/mutt-kz $HOME/mutt-kz_tmp > /dev/null
    #pushd $HOME/mutt-kz_tmp > /dev/null
    #./prepare --with-slang --enable-imap --enable-pop --with-ssl
    #make && sudo make install
    #popd > /dev/null
    #rm -rf $HOME/mutt-kz_tmp
fi

echo 'Setting fish as default shell'
chsh -s $(grep /fish$ /etc/shells | tail -1)

pushd $HOME/.dotfiles > /dev/null

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
sh ./symlinks.sh > /dev/null

popd > /dev/null

vim +PluginInstall +qall
