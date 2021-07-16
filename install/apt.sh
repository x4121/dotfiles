#!/bin/bash
set -e

# own ppa
if ! ls /etc/apt/sources.list.d/x4121* >/dev/null; then
    sudo add-apt-repository -y ppa:x4121/ppa >/dev/null
fi

SW="apt-transport-tor\
    ecryptfs-utils\
    fish\
        thefuck\
    htop\
    net-tools\
    neovim\
        universal-ctags\
    pwgen\
    ranger\
        atool\
        caca-utils\
        highlight\
    taskwarrior\
    torsocks\
    trash-cli"

if [[ $DISPLAY != "" ]]; then
    if ! ls /etc/apt/sources.list.d/nextcloud-devs* >/dev/null; then
        sudo add-apt-repository -y ppa:nextcloud-devs/client >/dev/null
    fi

    SW="$SW\
        chromium-browser\
        cmus\
        gawk\
        neomutt\
            isync\
            msmtp\
            notmuch\
            notmuch-mutt\
            urlview\
            w3m\
        network-manager-openvpn-gnome\
        newsboat\
        nextcloud-client-nautilus\
        pass\
        python-setuptools\
        python-pip\
        rofi\
        socat\
        tmux\
            xcape\
        virtualbox\
        wmctrl\
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
            plymouth-theme-ubuntu-gnome-logo"
    fi

    if [[ -n ${I_HOME+x} ]]; then
        SW="$SW\
            gimp\
            inkscape\
            playonlinux\
            steam\
            vlc"
    fi

    if [[ -n ${I_DEV+x} ]]; then
        # sbt
        if [ ! -f /etc/apt/sources.list.d/sbt.list ]; then
            echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" \
                | sudo tee -a /etc/apt/sources.list.d/sbt.list >/dev/null
        fi
        sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 \
            --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 >/dev/null
        # docker
        if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
            echo \
                "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
        fi
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
            sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

        if [ ! -f /etc/apt/sources.list.d/hashicorp.list ]; then
            echo "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
                | sudo tee -a /etc/apt/sources.list.d/hashicorp.list
        fi
        sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 \
            --recv-keys DA418C88A3219F7B >/dev/null


        SW="$SW\
            adb\
            build-essential\
                autoconf\
                automake\
                cmake\
                libtool\
            docker-ce\
                docker-ce-cli\
                containerd.io\
            golang\
            inotify-tools\
            jq\
            libwxgtk3.0-dev\
            rustc\
            sbt\
                maven\
                openjdk-8-jdk\
            shellcheck\
            terraform-ls"
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
