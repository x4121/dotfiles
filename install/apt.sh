#!/bin/bash

SW="apt-transport-tor\
    ecryptfs-utils\
    fish\
    fonts-lohit-knda\
    gnupg2\
    htop\
    mercurial\
    ranger\
        highlight\
    taskwarrior\
    torsocks\
    tree\
    vim-gnome-py2\
        exuberant-ctags"

if [[ $DISPLAY != "" ]]; then
    # owncloud
    wget -q -O - http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_16.04/Release.key \
        | sudo apt-key add - >&- 2>&-
    echo "deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_16.04/ /" \
        | sudo tee -a /etc/apt/sources.list.d/owncloud-client.list >&- 2>&-

    SW="$SW\
        chromium-browser\
        cmus\
        dconf-tools\
        devilspie\
        gawk\
        libsecret-tools\
        mutt-patched\
            msmtp\
            notmuch\
            notmuch-mutt\
            offlineimap\
            urlview\
            w3m\
            zsh\
        newsbeuter\
        owncloud-client\
        pass\
        pdfposter\
        pdf-presenter-console\
        python2-setuptools\
        redshift\
        rofi\
        rxvt-unicode-256color\
        samba\
        socat\
        tmux\
            wmctrl\
            xcape\
        unclutter\
        virtualbox\
        xdotool"

    if [[ $DESKTOP_SESSION = gnome ]]; then
        # arc-theme # remove in 16.10
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
        # sbt
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
            --recv 642AC823 >&- 2>&-
        echo "deb https://dl.bintray.com/sbt/debian /" \
            | sudo tee -a /etc/apt/sources.list.d/sbt.list >&- 2>&-
        # docker
        sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 \
            --recv-keys 58118E89F3A912897C070ADBF76221572C52609D - >&- 2>&-
        echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" \
            | sudo tee -a /etc/apt/sources.list.d/docker.list >&- 2>&-

        SW="$SW\
            build-essential\
                autoconf\
                automake\
                cmake\
                libtool\
            cabal-install\
            docker-engine\
            emacs\
            golang\
            jq\
            knockd\
            sbt\
                maven\
                openjdk-8-jdk\
                openjdk-9-jdk\
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
