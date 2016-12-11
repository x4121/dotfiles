#!/bin/bash

SW="apt-transport-tor\
    ecryptfs-utils\
    exuberant-ctags\
    fish\
    fonts-lohit-knda\
    gnupg2\
    htop\
    mercurial\
    ranger\
    taskwarrior\
    torsocks\
    tree\
    vim-gnome-py2"

if [[ $DISPLAY != "" ]]; then
    # gnome-keyring-query
    #sudo apt-add-repository -y ppa:wiktel/ppa >&- 2>&-
    # owncloud
    wget -q -O - http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_16.04/Release.key \
        | sudo apt-key add - >&- 2>&-
    echo "deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_16.04/ /" \
        | sudo tee -a /etc/apt/sources.list.d/owncloud-client.list >&- 2>&-

    SW="$SW\
        chromium-browser\
        dconf-tools\
        devilspie\
        gawk\
        mutt\
        owncloud-client\
        libsecret-tools\
        pass\
        pdf-presenter-console\
        python2-setuptools\
        redshift\
        rofi\
        rxvt-unicode-256color\
        samba\
        socat\
        tmux\
        urlview\
        virtualbox\
        w3m\
        wmctrl\
        xcape\
        xdotool"

    if [[ $DESKTOP_SESSION = gnome ]]; then
        # arc-theme
        wget -q -O - http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_15.04/Release.key \
            | sudo apt-key add - >&- 2>&-
        echo "deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /" \
            | sudo tee -a /etc/apt/sources.list.d/arc-theme.list >&- 2>&-
        # numix-icon-theme
        sudo add-apt-repository -y ppa:numix/ppa >&- 2>&-

        SW="$SW\
            arc-theme\
            gnome-tweak-tool\
            numix-icon-theme-circle
            "
    fi

    if ! [[ -z ${I_HOME+x} ]]; then
        SW="$SW\
            gimp\
            inkscape\
            nautilus-dropbox\
            playonlinux\
            steam\
            vlc"
    fi

    if ! [[ -z ${I_DEV+x} ]]; then
        # oracle java
        sudo apt-add-repository -y ppa:webupd8team/java >&- 2>&-
        echo debconf shared/accepted-oracle-license-v1-1 select true | \
              sudo debconf-set-selections
        echo debconf shared/accepted-oracle-license-v1-1 seen true | \
              sudo debconf-set-selections
        # sbt
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
            --recv 642AC823 >&- 2>&-
        echo "deb https://dl.bintray.com/sbt/debian /" \
            | sudo tee -a /etc/apt/sources.list.d/sbt.list >&- 2>&-
        # gradle
        sudo apt-add-repository -y ppa:cwchien/gradle >&- 2>&-
        # docker
        sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 \
            --recv-keys 58118E89F3A912897C070ADBF76221572C52609D - >&- 2>&-
        echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" \
            | sudo tee -a /etc/apt/sources.list.d/docker.list >&- 2>&-

        SW="$SW\
            autoconf\
            automake\
            build-essential\
            cabal-install\
            cmake\
            docker-engine\
            emacs\
            golang\
            gradle\
            jq\
            knockd\
            libtool\
            maven\
            openjdk-8-jdk\
            oracle-java9-installer\
            oracle-java8-set-default\
            sbt\
            texlive-full\
            vagrant"
    fi
fi

echo 'Updating/upgrading system'
sudo apt-get update >&- 2>&-
sudo apt-get upgrade -y >&- 2>&-

echo 'Installing software'
# shellcheck disable=2086
sudo apt-get install -y $SW >&- 2>&-
