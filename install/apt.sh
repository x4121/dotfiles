#!/bin/bash
set -e

SW="apt-transport-tor\
    ecryptfs-utils\
    fish\
    fzf\
    net-tools\
    universal-ctags\
    nmap\
    pwgen\
    python3\
        python3-pip\
        python3-venv\
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

	SW="$SW \
        cmus\
        flatpak\
        gawk\
        gparted\
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
        peek\
        wofi\
            wl-clipboard\
        socat\
        tmux\
        virtualbox\
        zathura"

	if [[ $DESKTOP_SESSION = ubuntu ]]; then
		# numix-icon-theme
		if ! ls /etc/apt/sources.list.d/numix* >/dev/null; then
			sudo add-apt-repository -y ppa:numix/ppa >/dev/null
		fi

		# chrome-gnome-shell is also required for Firefox
		SW="$SW \
            arc-theme\
            chrome-gnome-shell\
            gnome-session\
            gnome-tweaks\
            numix-icon-theme-circle"
	fi

	if [[ -n ${I_HOME+x} ]]; then
		SW="$SW \
            gimp\
            inkscape\
            playonlinux\
            steam\
            vlc"
	fi

	if [[ -n ${I_DEV+x} ]]; then
		# sbt
		if [ ! -f /etc/apt/sources.list.d/sbt.list ]; then
			echo "deb [signed-by=/usr/share/keyrings/sbt.gpg] \
                https://repo.scala-sbt.org/scalasbt/debian all main" |
				sudo tee /etc/apt/sources.list.d/sbt.list >/dev/null
			curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" |
				sudo gpg --dearmor -o /usr/share/keyrings/sbt.gpg
		fi
		# docker
		if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
			echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
                https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |
				sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
			curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
				sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
		fi
		# hashicorp
		if [ ! -f /etc/apt/sources.list.d/hashicorp.list ]; then
			echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
                https://apt.releases.hashicorp.com $(lsb_release -cs) main" |
				sudo tee /etc/apt/sources.list.d/hashicorp.list
			curl -fsSL https://apt.releases.hashicorp.com/gpg |
				sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
		fi

		SW="$SW \
            adb\
            build-essential\
                autoconf\
                automake\
                cmake\
                libtool\
            docker-ce\
                containerd.io\
                docker-buildx-plugin\
                docker-ce-cli\
                docker-compose-plugin\
            inotify-tools\
            jq\
            rpi-imager\
            sbt\
                maven\
                openjdk-11-jdk\
                openjdk-17-jdk\
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
