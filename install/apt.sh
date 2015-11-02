#!/bin/bash

# get dist codename
. /etc/os-release
if [[ $ID = ubuntu ]]; then
    grep CODENAME= /etc/os-release | tr -d '()"' | cut -d ' ' -f 2 | awk '{print "ubuntu-" tolower($0)}'
elif [[ $ID = debian ]]; then
    grep CODENAME= /etc/os-release | tr -d '()"' | cut -d ' ' -f 2 | awk '{print "debian-" tolower($0)}'
fi

echo 'Adding PPAs'
# own ppa
sudo apt-add-repository -y ppa:x4121/x4121 > /dev/null 2>&1

SW="exuberant-ctags fish htop mercurial taskwarrior tree vim-gnome"

if [ "$DISPLAY" != "" ]; then
    # GUI

    # gnome-keyring-query
    sudo apt-add-repository -y ppa:wiktel/ppa > /dev/null 2>&1
    # google chrome
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - > /dev/null
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee -a /etc/apt/sources.list.d/google.list > /dev/null 2>&1
    # scudcloud
    sudo apt-add-repository -y ppa:rael-gc/scudcloud > /dev/null 2>&1

    SW="$SW gnome-keyring-query guake mutt scudcloud tmux wmctrl"

    if ! [ -z ${I_HOME+x} ]; then
        echo "HOME"
    fi

    if ! [ -z ${I_DEV+x} ]; then
        # oracle java
        sudo apt-add-repository -y ppa:webupd8team/java > /dev/null 2>&1
        # sublime
        sudo apt-add-repository -y ppa:webupd8team/sublime-text-3 > /dev/null 2>&1
        # sbt
        echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list > /dev/null 2>&1
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
        # gradle
        sudo apt-add-repository -y ppa:cwchien/gradle > /dev/null 2>&1
        # docker
        echo "deb https://apt.dockerproject.org/repo $CODENAME main" | sudo tee -a /etc/apt/sources.list.d/docker.list > /dev/null 2>&1
        sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

        SW="$SW automake build-essential cmake golang oracle-java7-installer oracle-java8-installer"
        SW="$SW oracle-java8-set-default sbt sublime-text-installer"
    fi

fi

echo 'Updating/upgrading system'
sudo apt-get update > /dev/null
sudo apt-get upgrade -y > /dev/null

echo 'Installing software'
sudo apt-get install -y `echo ${SW}` > /dev/null
