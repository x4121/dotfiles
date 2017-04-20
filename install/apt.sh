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
    vim-gtk3\
        exuberant-ctags"

if [[ $DISPLAY != "" ]]; then
    # owncloud
    wget -q -O - http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_16.10/Release.key \
        | sudo apt-key add - >&- 2>&-
    echo "deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_16.10/ /" \
        | sudo tee -a /etc/apt/sources.list.d/owncloud-client.list >&- 2>&-

    SW="$SW\
        chromium-browser\
        cmus\
        dconf-tools\
        devilspie\
        gawk\
        libsecret-tools\
        mutt\
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
        python-setuptools\
        rofi\
        rxvt-unicode-256color\
        samba\
        socat\
        stjerm\
        tmux\
            wmctrl\
            xcape\
        unclutter\
        virtualbox\
        xdotool"

    if [[ $DESKTOP_SESSION = gnome ]]; then
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
        sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 \
            --recv 642AC823 >&- 2>&-
        echo "deb https://dl.bintray.com/sbt/debian /" \
            | sudo tee -a /etc/apt/sources.list.d/sbt.list >&- 2>&-
        # docker
        sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 \
            --recv-keys 58118E89F3A912897C070ADBF76221572C52609D >&- 2>&-
        echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" \
            | sudo tee -a /etc/apt/sources.list.d/docker.list >&- 2>&-

        SW="$SW\
            build-essential\
                autoconf\
                automake\
                cmake\
                libtool\
            docker-engine\
            emacs\
            jq\
            knockd\
            npm\
                node-grunt-cli\
            rbenv\
                ruby-build\
            sbt\
                maven\
                openjdk-8-jdk\
            shellcheck\
            texlive-full\
            vagrant"
    fi
fi

echo 'Updating/upgrading system'
if ! sudo apt update; then
    echo 'Something failed (maybe a keyserver was down)'
    echo 'Stopping'
    return 1
fi
sudo apt upgrade -y >&- 2>&-

echo 'Installing software'
# shellcheck disable=2086
sudo apt install -y $SW >&- 2>&-
