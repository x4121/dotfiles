#!/bin/bash
set -e

# own ppa
if ! ls /etc/apt/sources.list.d/x4121* >/dev/null; then
    sudo add-apt-repository -y ppa:x4121/ppa >/dev/null
    sudo add-apt-repository -y ppa:x4121/ripgrep >/dev/null
fi

SW="apt-transport-tor\
    ecryptfs-utils\
    fish\
        thefuck\
    fonts-lohit-knda\
    htop\
    mercurial\
    net-tools\
    pwgen\
    ranger\
        atool\
        caca-utils\
        highlight\
    ripgrep\
    taskwarrior\
    torsocks\
    tree\
    vim-gtk3\
        exuberant-ctags"

if [[ $DISPLAY != "" ]]; then
    SW="$SW\
        cargo\
        chromium-browser\
        cmus\
        dconf-tools\
        devilspie\
        gawk\
        mutt\
            msmtp\
            notmuch\
            notmuch-mutt\
            offlineimap\
            urlview\
            w3m\
        newsbeuter\
        nextcloud-client-nautilus\
        pass\
        python-setuptools\
        rofi\
        socat\
        tmux\
            xcape\
        virtualbox\
        xdotool\
        zathura"

    if [[ $DESKTOP_SESSION = gnome ]]; then
        # numix-icon-theme
        if ! ls /etc/apt/sources.list.d/numix* >/dev/null; then
            sudo add-apt-repository -y ppa:numix/ppa >/dev/null
        fi

        SW="$SW\
            arc-theme\
            chrome-gnome-shell\
            gnome-session\
            gnome-tweak-tool\
            numix-icon-theme-circle\
            plymouth-theme-ubuntu-gnome-logo\
            ubuntu-gnome-wallpapers-yakkety"
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
        if [ ! -f /etc/apt/sources.list.d/sbt.list ]; then
            echo "deb https://dl.bintray.com/sbt/debian /" \
                | sudo tee -a /etc/apt/sources.list.d/sbt.list >/dev/null
        fi
        sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 \
            --recv 642AC823 >/dev/null
        # docker
        if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
            echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" \
                | sudo tee -a /etc/apt/sources.list.d/docker.list >/dev/null
        fi
        sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 \
            --recv-keys 58118E89F3A912897C070ADBF76221572C52609D >/dev/null

        SW="$SW\
            build-essential\
                autoconf\
                automake\
                cmake\
                libtool\
            docker-engine\
            jq\
            knockd\
            rustc\
            sbt\
                maven\
                nailgun\
                openjdk-8-jdk\
            shellcheck\
            vagrant"
    fi
fi

echo 'Updating/upgrading system'
if ! sudo apt update; then
    echo 'Something failed (maybe a keyserver was down)'
    echo 'Stopping'
    return 1
fi
sudo apt upgrade -y >/dev/null

echo 'Installing software'
# shellcheck disable=2086
sudo apt install -y $SW
