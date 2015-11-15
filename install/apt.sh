#!/bin/bash

# get dist codename
. /etc/os-release
if [[ $ID = ubuntu ]]; then
    CODENAME=`grep VERSION= /etc/os-release | tr -d '()"' | cut -d ' ' -f 2 | awk '{print "ubuntu-" tolower($0)}'`
elif [[ $ID = debian ]]; then
    CODENAME=`grep VERSION= /etc/os-release | tr -d '()"' | cut -d ' ' -f 2 | awk '{print "debian-" tolower($0)}'`
fi

echo 'Adding PPAs'
# own ppa
sudo apt-add-repository -y ppa:x4121/x4121 >&- 2>&-

SW="exuberant-ctags\
    fish\
    gpgv2\
    htop\
    mercurial\
    taskwarrior\
    tree\
    vim-gnome"

if [ "$DISPLAY" != "" ]; then
    # gnome-keyring-query
    sudo apt-add-repository -y ppa:wiktel/ppa >&- 2>&-
    # google chrome
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub \
        | sudo apt-key add - >&- 2>&-
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" \
        | sudo tee -a /etc/apt/sources.list.d/google.list >&- 2>&-
    # scudcloud
    sudo apt-add-repository -y ppa:rael-gc/scudcloud >&- 2>&-
    # owncloud
    sudo apt-key adv --keyserver keyserver.ubuntu.com \
        --recv-keys 977C43A8BA684223 >&- 2>&-
    echo "deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_15.04/ /" \
        | sudo tee -a /etc/apt/sources.list.d/owncloud-client.list >&- 2>&-

    SW="$SW\
        compizconfig-settings-manager\
        compiz-plugins-extra\
        gnome-keyring-query\
        gnome-tweak-tool\
        google-chrome-stable\
        guake\
        mutt\
        scudcloud\
        tmux\
        unity-tweak-tool\
        wmctrl"

    if ! [ -z ${I_HOME+x} ]; then
        SW="$SW\
            eiskaltdcpp-qt\
            gimp\
            inkscape\
            nautilus-dropbox\
            playonlinux\
            steam\
            vlc"
    fi

    if ! [ -z ${I_DEV+x} ]; then
        # oracle java
        sudo apt-add-repository -y ppa:webupd8team/java >&- 2>&-
        # sublime
        sudo apt-add-repository -y ppa:webupd8team/sublime-text-3 >&- 2>&-
        # sbt
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
            --recv 642AC823 >&- 2>&-
        echo "deb https://dl.bintray.com/sbt/debian /" \
            | sudo tee -a /etc/apt/sources.list.d/sbt.list >&- 2>&-
        # gradle
        sudo apt-add-repository -y ppa:cwchien/gradle >&- 2>&-
        # docker
        sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 \
            --recv-keys 58118E89F3A912897C070ADBF76221572C52609D >&- 2>&-
        echo "deb https://apt.dockerproject.org/repo $CODENAME main" \
            | sudo tee -a /etc/apt/sources.list.d/docker.list >&- 2>&-

        SW="$SW\
            automake\
            build-essential\
            cmake\
            docker-engine\
            golang\
            gradle\
            maven\
            oracle-java7-installer\
            oracle-java8-installer\
            oracle-java8-set-default\
            sbt\
            sublime-text-installer\
            texlive-full"
    fi
fi

echo 'Updating/upgrading system'
sudo apt-get update >&- 2>&-
sudo apt-get upgrade -y >&- 2>&-

echo 'Installing software'
sudo apt-get install -y `echo ${SW}` >&- 2>&-
