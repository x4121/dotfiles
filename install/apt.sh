#!/bin/bash

SW="apt-transport-tor\
    ecryptfs-utils\
    exuberant-ctags\
    fish\
    gnupg2\
    htop\
    mercurial\
    ranger\
    taskwarrior\
    torsocks\
    tree\
    vim-gnome"

if [ "$DISPLAY" != "" ]; then
    # gnome-keyring-query
    #sudo apt-add-repository -y ppa:wiktel/ppa >&- 2>&-
    # scudcloud
    sudo apt-add-repository -y ppa:rael-gc/scudcloud >&- 2>&-
    # owncloud
    wget -q -O - http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_16.04/Release.key \
        | sudo apt-key add - >&- 2>&-
    echo "deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_16.04/ /" \
        | sudo tee -a /etc/apt/sources.list.d/owncloud-client.list >&- 2>&-
    # f.lux
    sudo add-apt-repository ppa:nathan-renniewaldock/flux >&- 2>&-

    SW="$SW\
        chromium-browser\
        dconf-tools\
        devilspie\
        fluxgui\
        gawk\
        gnome-tweak-tool\
        guake\
        mr\
        mutt\
        owncloud-client\
        pdf-presenter-console\
        python3-setuptools\
        rofi\
        rxvt-unicode-256color\
        samba\
        scudcloud\
        socat\
        tmux\
        urlview\
        virtualbox\
        w3m\
        xdotool"

    if ! [ -z ${I_HOME+x} ]; then
        SW="$SW\
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
        # sbt
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
            --recv 642AC823 >&- 2>&-
        echo "deb https://dl.bintray.com/sbt/debian /" \
            | sudo tee -a /etc/apt/sources.list.d/sbt.list >&- 2>&-
        # gradle
        sudo apt-add-repository -y ppa:cwchien/gradle >&- 2>&-
        # docker
        curl -sSL https://get.docker.com/gpg \
            | sudo apt-key add - >&- 2>&-
        curl -sSL https://get.docker.com/ | sh >&- 2>&-
        sudo usermod -aG docker $USER >&- 2>&-

        SW="$SW\
            automake\
            build-essential\
            cmake\
            emacs\
            golang\
            gradle\
            jq\
            maven\
            openjdk-8-jdk\
            oracle-java7-installer\
            oracle-java8-installer\
            sbt\
            texlive-full\
            vagrant"
    fi
fi

echo 'Updating/upgrading system'
sudo apt-get update >&- 2>&-
sudo apt-get upgrade -y >&- 2>&-

echo 'Installing software'
sudo apt-get install -y `echo ${SW}` >&- 2>&-
