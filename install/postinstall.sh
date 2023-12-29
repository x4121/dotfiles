#!/bin/bash
set -e

echo 'Disable annoying apt-esm advertisement'
sudo rm /etc/apt/apt.conf.d/20apt-esm-hook.conf
sudo touch /etc/apt/apt.conf.d/20apt-esm-hook.conf

echo 'Installing Interception Tools'
# deb package in repository doesn't work for Ubuntu 22.04
# sudo add-apt-repository -y ppa:deafmute/interception
tmp="$(mktemp -d)"
sudo apt-install -y \
    cmake libevdev-dev libudev-dev libyaml-cpp-dev libboost-dev
git clone https://gitlab.com/interception/linux/tools.git "$tmp" >/dev/null
pushd "$tmp" >/dev/null
cmake -B build -DCMAKE_BUILD_TYPE=Release
sudo cmake --build build --target install
popd >/dev/null
rm -rf "$tmp"
tmp="$(mktemp -d)"
git clone https://gitlab.com/interception/linux/plugins/dual-function-keys.git "$tmp" > /dev/null
pushd "$tmp" >/dev/null
make && sudo make install
popd >/dev/null
rm -rf "$tmp"
sed 's/ExecStart.*/ExecStart=\/usr\/local\/bin\/udevmon/' \
    udevmon.service | sudo tee /etc/systemd/system/udevmon.service
sudo mkdir -p /etc/interception
sudo chown -R "$USER":sudo /etc/interception
ln -s "$HOME/.interception-tools/udevmon.d" /etc/interception/
ln -s "$HOME/.interception-tools/dual-function-keys.yaml" /etc/interception/
sudo systemctl daemon-reload
sudo systemctl enable udevmon.service

if [[ -n ${I_DEV+x} ]]; then
    echo 'Installing asdf'

    sudo apt-get install -y \
        libssl-dev libncurses5-dev libreadline-dev zlib1g-dev >/dev/null
    git clone https://github.com/asdf-vm/asdf.git \
        "$HOME/.asdf" --branch v0.13.1 >/dev/null
    mkdir -p "$HOME/.config/fish/completions"
    ln -s "$HOME/.asdf/completions/asdf.fish" "$HOME/.config/fish/completions"

    # shellcheck disable=SC1090
    asdf plugin-add nodejs
    asdf install nodejs 8.17.0
    asdf install nodejs 16.20.2
    asdf install nodejs 18.19.0
    asdf global nodejs 18.19.0
    ln -s "$HOME/.asdf/installs/nodejs/18.19.0" "$HOME/.asdf/installs/nodejs/latest"
    ln -s "$HOME/.asdf/installs/nodejs/18.19.0" "$HOME/.asdf/installs/nodejs/18"
    ln -s "$HOME/.asdf/installs/nodejs/18.19.0" "$HOME/.asdf/installs/nodejs/18.19"
    ln -s "$HOME/.asdf/installs/nodejs/16.20.2" "$HOME/.asdf/installs/nodejs/16"
    ln -s "$HOME/.asdf/installs/nodejs/16.20.2" "$HOME/.asdf/installs/nodejs/16.20"

    asdf plugin-add terraform
    asdf install terraform 0.12.18
    asdf install terraform 0.13.7
    asdf install terraform 1.1.8
    asdf install terraform 1.3.2
    asdf global terraform 1.3.2

    echo 'Installing vscode'
    curl -fLo \
        'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' \
        /tmp/code.deb
    sudo dpkg -i /tmp/code.deb
    sudo apt-get install -f

    echo 'Installing rust'
    CARGO_HOME=/opt/cargo
    RUSTUP_HOME=/opt/rustup
    sudo mkdir $CARGO_HOME $RUSTUP_HOME
    sudo chown "$USER":sudo $CARGO_HOME $RUSTUP_HOME
    sudo chmod g+w $CARGO_HOME $RUSTUP_HOME
    export RUSTUP_HOME
    export CARGO_HOME
    curl https://sh.rustup.rs -sSf |
        sh -s -- --default-toolchain stable --profile default \
        --no-modify-path -y >/dev/null
    # shellcheck disable=SC1090
    source "/opt/cargo/env"
    rustup default stable
    mkdir -p "$HOME/.config/fish/completions"
    rustup completions fish >"$HOME/.config/fish/completions/rustup.fish"

    cargo install \
        bat \
        bottom \
        cargo-audit \
        cargo-outdated \
        cargo-tarpaulin \
        cargo-update \
        cargo-watch \
        du-dust \
        exa \
        fd-find \
        git-trim \
        grex \
        navi \
        procs \
        requestr-cli \
        ripgrep \
        scaffold \
        starship \
        zoxide \
        ;
    starship completions fish >"$HOME/.config/fish/completions/starship.fish"

    echo 'Setting alacritty as default terminal'
    sudo update-alternatives --install \
        /etc/alternatives/x-terminal-emulator \
        x-terminal-emulator \
        "$(command -v alacritty)" \
        1000
    sudo ln -sf /etc/alternatives/x-terminal-emulator /usr/bin/x-terminal-emulator

    echo 'Setting up docker user permissions'
    sudo adduser "$USER" docker

    echo 'Adding user to plugdev for adb'
    sudo adduser "$USER" plugdev

    echo 'Installing coursier'
    tmp="$(mktemp -d)"
    pushd "$tmp" >/dev/null
    curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > cs
    chmod +x cs
    COURSIER_INSTALL_DIR=/usr/local/coursier/bin
    export COURSIER_INSTALL_DIR
    sudo mkdir -p $COURSIER_INSTALL_DIR
    sudo chown "$USER":sudo $COURSIER_INSTALL_DIR
    sudo chmod g+w $COURSIER_INSTALL_DIR
    ./cs install cs scalafmt ammonite
    popd >/dev/null
    rm -rf "$tmp"

    echo 'Installing git-lfs'
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
    sudo apt install git-lfs
    git lfs install

    echo 'Installing pre-commit'
    python3 -m pip install pre-commit

    echo 'Installing typescript and stuff'
    npm install -g eslint typescript prettier yarn

    echo 'Installing AWS cli'
    python3 -m pip install awscli-update
    awscli-update -q --prefix "$HOME/.local"
    (crontab -l; echo "0 * * * * \$HOME/.local/bin/awscli-update -q --prefix \$HOME/.local") \
        | sort -u | crontab -

    echo 'Installing granted'
    tmp="$(mktemp -d)"
    pushd "$tmp" >/dev/null
    granted_version="$(curl -Lso /dev/null -w '%{url_effective}' \
        'https://github.com/common-fate/granted/releases/latest' \
        | rev | cut -d'/' -f1 | rev)"
    curl -L \
        "https://releases.commonfate.io/granted/$granted_version/granted_${granted_version:1}_linux_x86_64.tar.gz" \
        -o granted.tar.gz
    tar -zxf granted.tar.gz
    sudo cp assume assumego granted /usr/local/bin/
    cp assume.fish "$HOME/.config/fish/functions/"
    popd >/dev/null
    rm -rf "$tmp"
fi

pushd "$HOME/.dotfiles" >/dev/null

if [[ $DISPLAY != "" ]]; then
    echo 'Installing rofi-pass'
    tmp="$(mktemp -d)"
    git clone https://github.com/carnager/rofi-pass "$tmp" >/dev/null
    pushd "$tmp" >/dev/null
    sudo make install
    popd >/dev/null
    rm -rf "$tmp"

    echo 'Installing nerd-fonts'
    fonts_version="$(curl -Lso /dev/null -w '%{url_effective}' \
        'https://github.com/ryanoasis/nerd-fonts/releases/latest' \
        | rev | cut -d'/' -f1 | rev)"
    fontUrl="https://github.com/ryanoasis/nerd-fonts/releases/download/$fonts_version/"
    mkdir -p "$HOME/.local/share/fonts"
    pushd "$HOME/.local/share/fonts" >/dev/null
    curl -L \
        "$fontUrl/SourceCodePro.zip" | jar xv
    curl -L \
        "$fontUrl/FiraMono.zip" | jar xv
    curl -L \
        "$fontUrl/FiraCode.zip" | jar xv
    fc-cache -f
    popd >/dev/null

    echo 'Installing mutt dependencies'
    python3 -m pip install mutt_ics vobject \
        gcalcli

    echo 'Installing snaps'
    sudo snap install \
        discord \
        postman \
        roll \
        slack \
        spotify \
        ;
    sudo snap install --classic \
        alacritty \
        hub \
        nvim \
        ;

    echo 'Installing flathub'
    sudo flatpak remote-add --if-not-exists flathub \
        https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub com.github.tchx84.Flatseal
    flatpak install -y flathub com.dec05eba.gpu_screen_recorder
fi

if [[ $DESKTOP_SESSION = ubuntu ]]; then
    echo 'Installing gnome-shell extensions'
    gnomeshell_install="$HOME/.dotfiles/symlinks/bin.symlink/gnomeshell-extension-manage \
        --install --extension-id"
    # user themes
    $gnomeshell_install 19
    # dash to dock
    $gnomeshell_install 307
    # openweather
    $gnomeshell_install 750
    # topicons plus
    $gnomeshell_install 1031
    # no annoyance
    $gnomeshell_install 2182
    # ddterm
    $gnomeshell_install 3780

    echo 'Configuring gnome-shell extensions'
    ext_home="$HOME/.local/share/gnome-shell/extensions"
    schema_dir=/usr/share/glib-2.0/schemas/
    sudo cp \
        "$ext_home/dash-to-dock@micxgx.gmail.com/schemas/org.gnome.shell.extensions.dash-to-dock.gschema.xml" \
        "$ext_home/ddterm@amezin.github.com/schemas/com.github.amezin.ddterm.gschema.xml" \
        "$ext_home/noannoyance@daase.net//schemas/org.gnome.shell.extensions.noannoyance.gschema.xml" \
        "$ext_home/openweather-extension@jenslody.de/schemas/org.gnome.shell.extensions.openweather.gschema.xml" \
        "$ext_home/user-theme@gnome-shell-extensions.gcampax.github.com/schemas/org.gnome.shell.extensions.user-theme.gschema.xml" \
        $schema_dir
    sudo glib-compile-schemas $schema_dir

    # dash to dock
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        apply-custom-theme false
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        custom-theme-customize-running-dots true
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        custom-theme-shrink true
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        dash-max-icon-size 32
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        dock-fixed true
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        dock-position 'LEFT'
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        extend-height true
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        running-indicator-style 'DOTS'
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        show-show-apps-button false
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        show-mounts false
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        show-trash false

    # ddterm
    gsettings set com.github.amezin.ddterm \
        command 'custom-command'
    gsettings set com.github.amezin.ddterm \
        custom-command 'tmux new-session -A -s dropdown'
    gsettings set com.github.amezin.ddterm \
        custom-font 'FiraMono Nerd Font 12'
    gsettings set com.github.amezin.ddterm \
        background-color '#282828'
    gsettings set com.github.amezin.ddterm \
        foreground-color '#ebdbb2'
    gsettings set com.github.amezin.ddterm \
        notebook-border false
    gsettings set com.github.amezin.ddterm \
        palette "['#282828', '#cc241d', '#98971a', '#d79921', '#458588', '#b16286', '#689d6a', '#a89984', '#928374', '#fb4934', '#b8bb26', '#fabd2f', '#83a598', '#d3869b', '#8ec07c', '#ebdbb2']"
    gsettings set com.github.amezin.ddterm \
        panel-icon-type 'none'
    gsettings set com.github.amezin.ddterm \
        show-scrollbar false
    gsettings set com.github.amezin.ddterm \
        tab-policy 'never'
    gsettings set com.github.amezin.ddterm \
        use-system-font false
    gsettings set com.github.amezin.ddterm \
        use-theme-colors false
    gsettings set com.github.amezin.ddterm \
        window-monitor 'focus'
    gsettings set com.github.amezin.ddterm \
        window-resizable false
    gsettings set com.github.amezin.ddterm \
        window-size 0.34

    # no annoyance
    gsettings set org.gnome.shell.extensions.noannoyance \
        enable-ignorelist false

    # openweather
    gsettings set org.gnome.shell.extensions.openweather \
        pressure-unit 'hPa'
    gsettings set org.gnome.shell.extensions.openweather \
        unit 'celsius'
    gsettings set org.gnome.shell.extensions.openweather \
        wind-speed-unit 'kph'
    gsettings set org.gnome.shell.extensions.openweather \
        city '48.7630165,11.4250395>Ingolstadt, Bayern, Deutschland>0'

    # user theme
    gsettings set org.gnome.shell.extensions.user-theme \
        name 'Arc-Dark'

    # enable extensions
    gsettings set org.gnome.shell enabled-extensions \
        "['openweather-extension@jenslody.de', 'ddterm@amezin.github.com', 'noannoyance@daase.net', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com']"


    echo 'Setting keyboard shortcuts'
    gsettings set org.gnome.desktop.input-sources xkb-options \
        "['compose:ralt', 'shift:both_capslock_cancel']"
    gsettings set org.gnome.desktop.wm.keybindings \
        switch-input-source "[]"
    gsettings set org.gnome.desktop.wm.keybindings \
        switch-input-source-backward "[]"
    kb_sch='org.gnome.settings-daemon.plugins.media-keys.custom-keybinding'
    kb_dir='/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings'

    kb_list='['
    for i in $(seq 0 7); do
        kb_list="$kb_list'$kb_dir/custom$i/', "
    done
    kb_list="${kb_list/%, /]}"
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
        "$kb_list"
    gsettings set $kb_sch:$kb_dir/custom0/ name 'Nautilus'
    gsettings set $kb_sch:$kb_dir/custom0/ command 'nautilus'
    gsettings set $kb_sch:$kb_dir/custom0/ binding '<Super>e'
    gsettings set $kb_sch:$kb_dir/custom1/ name 'Rofi run'
    gsettings set $kb_sch:$kb_dir/custom1/ command 'rofi -combi-modi run,window,drun -show combi'
    gsettings set $kb_sch:$kb_dir/custom1/ binding '<Super>space'
    gsettings set $kb_sch:$kb_dir/custom2/ name 'Rofi soundboard'
    gsettings set $kb_sch:$kb_dir/custom2/ command "$HOME/.dotfiles/etc/rofi-soundboard/rofi-soundboard"
    gsettings set $kb_sch:$kb_dir/custom2/ binding 'F9'
    gsettings set $kb_sch:$kb_dir/custom3/ name 'Rofi pass'
    gsettings set $kb_sch:$kb_dir/custom3/ command 'rofi-pass --last-used'
    gsettings set $kb_sch:$kb_dir/custom3/ binding 'F8'
    gsettings set $kb_sch:$kb_dir/custom4/ name 'Tmux'
    gsettings set $kb_sch:$kb_dir/custom4/ command "alacritty -e tmux new-session -A -s tmux"
    gsettings set $kb_sch:$kb_dir/custom4/ binding '<Super>Return'
    gsettings set $kb_sch:$kb_dir/custom5/ name 'System Monitor'
    gsettings set $kb_sch:$kb_dir/custom5/ command 'gnome-system-monitor'
    gsettings set $kb_sch:$kb_dir/custom5/ binding '<Primary><Shift>Escape'
    gsettings set $kb_sch:$kb_dir/custom6/ name 'xkill'
    gsettings set $kb_sch:$kb_dir/custom6/ command 'xkill'
    gsettings set $kb_sch:$kb_dir/custom6/ binding '<Super>k'

    echo 'Additional settings'
    gsettings set org.gnome.desktop.wm.preferences \
        button-layout "appmenu:minimize,maximize,close"
    gsettings set org.gnome.desktop.interface \
        clock-show-date true
    gsettings set org.gnome.desktop.interface \
        gtk-theme 'Arc-Dark'
    gsettings set org.gnome.desktop.interface \
        icon-theme 'Numix-Circle'
    gsettings set org.gnome.settings-daemon.plugins.color \
        night-light-enabled true
    gsettings set org.gnome.shell.window-switcher \
        current-workspace-only false
    gsettings set org.gnome.desktop.background picture-uri \
        "file:///$HOME/Nextcloud/sync/background.jpg"
    gsettings set org.gnome.desktop.screensaver picture-uri \
        "file:///$HOME/Nextcloud/sync/lockscreen.jpg"
fi

echo 'Creating symlinks'
bash ./symlinks.sh >/dev/null

popd >/dev/null

echo 'Setting fish as default shell'
sudo chsh -s "$(grep /fish$ /etc/shells | tail -1)" "$USER"

echo 'Installing tmux plugins'
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

echo 'Setting up ranger'
ranger --copy-config=scope

echo 'Enabling mail sync'
mkdir -p "$HOME/Mail/armingrodon.de"
mkdir -p "$HOME/Mail/gmail.com"
mkdir -p "$HOME/Mail/ryte.com"
systemctl --user enable mbsync.timer
systemctl --user start mbsync.timer

echo 'Setting app defaults'
localdefaults=$HOME/.local/share/applications/defaults.list
systemdefaults=/usr/share/applications/defaults.list
mimehead="[Default Applications]"
if [[ ! -f $localdefaults ]]; then
    rm -rf "$localdefaults"
    touch "$localdefaults"
fi
if grep -vq "$mimehead" "$localdefaults"; then
    echo "$mimehead" >"$localdefaults"
fi

grep evince\.desktop $systemdefaults |
    sed 's/=evince\.desktop/=zathura.desktop/' \
        >>"$localdefaults"
grep gedit\.desktop $systemdefaults |
    sed 's/=.*gedit\.desktop.*/=nvim.desktop/' \
        >>"$localdefaults"
