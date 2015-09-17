#!/bin/bash

echo 'Installing dotfiles'

apt > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo 'Cannot run apt'
    return -1
fi

echo 'Adding PPAs'
# oracle java
sudo apt-add-repository -y ppa:webupd8team/java > /dev/null 2>&1
# sublime
sudo apt-add-repository -y ppa:webupd8team/sublime-text-3 > /dev/null 2>&1
# gnome-keyring-query
sudo apt-add-repository -y ppa:wiktel/ppa > /dev/null 2>&1
# sbt
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list > /dev/null 2>&1
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
# google chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - > /dev/null
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee -a /etc/apt/sources.list.d/google.list > /dev/null 2>&1
# scudcloud / slack
sudo apt-add-repository -y ppa:rael-gc/scudcloud > /dev/null 2>&1

echo 'Updating system'
sudo apt-get update > /dev/null

echo 'Installing basics'
sudo apt-get install -y exuberant-ctags git\
    htop tmux vim-gnome zsh guake xclip mutt\
    gnome-keyring-query wmctrl

echo 'Installing st'
git clone https://github.com/x4121/st $HOME/st_tmp > /dev/null
pushd $HOME/st_tmp > /dev/null
make && sudo make install
popd > /dev/null
rm -rf $HOME/st_tmp

#echo 'Installing mutt'
#sudo apt-get install -y autoconf libslang2-dev libiconv-hook-dev libssl-dev > /dev/null
#git clone https://github.com/karelzak/mutt-kz $HOME/mutt-kz_tmp > /dev/null
#pushd $HOME/mutt-kz_tmp > /dev/null
#./prepare --with-slang --enable-imap --enable-pop --with-ssl
#make && sudo make install
#popd > /dev/null
#rm -rf $HOME/mutt-kz_tmp

#echo 'Installing keepassx'
# dependencies?
#git clone https://github.com/x4121/keepassx $HOME/keepassx_tmp > /dev/null
#mkdir $HOME/keepassx_tmp/build
#pushd $HOME/keepassx_tmp/build > /dev/null
#cmake .. && make -j4 && sudo make install
#popd > /dev/null
#rm -rf $HOME/keepassx_tmp

#echo 'Installing additional software'
#sudo apt-get install -y oracle-java7-installer oracle-java8-installer\
#    oracle-java8-set-default sublime-text-installer scudcloud

if [ ! -d "$HOME/.fonts" ]; then
    mkdir $HOME/.fonts
fi

echo 'Setting zsh as default shell'
chsh -s $(grep /zsh$ /etc/shells | tail -1)

echo 'Initializing submodule(s)'
git submodule update --init --recursive

echo 'Installing powerline fonts'
source powerline_fonts/install.sh

echo 'Setting font and color'
profile=$(dconf read /org/gnome/terminal/legacy/profiles:/default | tr -d "'")
if [ "$profile" = "" ]; then
    profile=$(dconf list /org/gnome/terminal/legacy/profiles:/ | tr -d ":/")
fi
dconf write /org/gnome/terminal/legacy/profiles:/:$profile/visible-name "'Default'"
dconf write /org/gnome/terminal/legacy/profiles:/:$profile/font "'Source Code Pro for Powerline Medium 12'"
dconf write /org/gnome/terminal/legacy/profiles:/:$profile/use-system-font "false"

gnome-terminal-colors-solarized/install.sh -s dark -p Default

sh ./symlinks.sh	
