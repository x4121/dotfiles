#!/bin/bash
set -e

if ! [[ -z ${I_DEV+x} ]]; then
    echo 'Installing jenv'
    git clone https://github.com/gcuisinier/jenv.git \
        "$HOME/.jenv" >/dev/null
    mkdir -p "$HOME/.config/fish/functions"
    ln -s "$HOME/.jenv/fish/export.fish" \
        "$HOME/.config/fish/functions/export.fish" >/dev/null
    ln -s "$HOME/.jenv/fish/jenv.fish" \
        "$HOME/.config/fish/functions/jenv.fish" >/dev/null

    echo 'Installing gems'
    sudo gem install \
        gem-shut-the-fuck-up bundler git-amnesia git-rc >/dev/null
fi

echo 'Installing git-lfs'
tmp="$(mktemp -d)"
pushd "$tmp" >/dev/null
curl -fLo "lfs.tgz" \
    "https://github.com/git-lfs/git-lfs/releases/download/v1.5.5/git-lfs-linux-amd64-1.5.5.tar.gz" \
    2>/dev/null
tar xzf "lfs.tgz" --strip-components 1
sudo mkdir -p /usr/local/bin
sudo install git-lfs /usr/local/bin/git-lfs
git lfs install
popd >/dev/null
rm -rf "$tmp"

pushd "$HOME/.dotfiles" >/dev/null

if [[ $DISPLAY != "" ]]; then
    echo 'Installing pip'
    sudo easy_install pip >/dev/null

    echo 'Installing rofi-pass'
    tmp="$(mktemp -d)"
    git clone https://github.com/carnager/rofi-pass "$tmp" >/dev/null
    pushd "$tmp" >/dev/null
    sudo make install
    popd >/dev/null
    rm -rf "$tmp"

    echo 'Installing nerd-fonts'
    fontUrl="https://github.com/ryanoasis/nerd-fonts/raw/0.9.0/patched-fonts/SourceCodePro"
    mkdir -p "$HOME/.local/share/fonts"
    pushd "$HOME/.local/share/fonts" >/dev/null
    OLDIFS=$IFS; IFS=','
    for i in Medium,%20Medium Regular,"" Bold,%20Bold; do
        set -- $i
        curl -fLo "SauceCodeProNerd $1.ttf" \
            "$fontUrl/$1/complete/Sauce%20Code%20Pro$2%20Nerd%20Font%20Complete%20Mono.ttf" \
            2>/dev/null
    done
    IFS=$OLDIFS
    popd >/dev/null

    echo 'Installing mutt dependencies'
    sudo pip install mutt_ics vobject
    sudo pip install gcalcli

    echo 'Install Franz'
    sudo mkdir -p /opt/franz
    sudo wget -O /opt/franz/Franz.tgz \
        https://github.com/meetfranz/franz-app/releases/download/4.0.4/Franz-linux-x64-4.0.4.tgz \
        2>/dev/null
    sudo tar xzf /opt/franz/Franz.tgz -C /opt/franz
    sudo rm /opt/franz/Franz.tgz

    echo 'Setting chromium as default browser'
    sudo update-alternatives --set gnome-www-browser "$(which chromium-browser)"
    sudo update-alternatives --set x-www-browser "$(which chromium-browser)"
fi

if [[ $DESKTOP_SESSION = gnome ]]; then
    echo 'Installing gnome-shell extensions'
    gnomeshell_install="$HOME/.dotfiles/bin.symlink/gnomeshell-extension-manage \
        --install --extension-id"
    # media player indicator
    $gnomeshell_install 55
    # dash to dock
    $gnomeshell_install 307
    # topicons plus
    $gnomeshell_install 1031
    # no topleft hot corner
    $gnomeshell_install 118
    # notification alert
    #$gnomeshell_install 258
    # openweather
    $gnomeshell_install 750

    echo 'Configuring gnome-shell extensions'
    ext_home="$HOME/.local/share/gnome-shell/extensions"
    schema_dir=/usr/share/glib-2.0/schemas/
    sudo cp \
        "$ext_home/dash-to-dock@micxgx.gmail.com/schemas/org.gnome.shell.extensions.dash-to-dock.gschema.xml" \
        "$ext_home/mediaplayer@patapon.info/schemas/org.gnome.shell.extensions.mediaplayer.gschema.xml" \
        "$ext_home/openweather-extension@jenslody.de/schemas/org.gnome.shell.extensions.openweather.gschema.xml" \
        "$ext_home/TopIcons@phocean.net/schemas/org.gnome.shell.extensions.topicons.gschema.xml" \
        $schema_dir
    sudo glib-compile-schemas $schema_dir
    # dash to dock
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        custom-theme-customize-running-dots true
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        custom-theme-running-dots true
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        custom-theme-shrink true
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        dash-max-icon-size 32
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        extend-height true
    gsettings set org.gnome.shell.extensions.dash-to-dock \
        show-show-apps-button false
    # topicons plus
    gsettings set org.gnome.shell.extensions.topicons \
        icon-opacity 250
    gsettings set org.gnome.shell.extensions.topicons \
        icon-size 19
    gsettings set org.gnome.shell.extensions.topicons \
        icon-spacing 9
    # openweather
    gsettings set org.gnome.shell.extensions.openweather \
        pressure-unit 'hPa'
    gsettings set org.gnome.shell.extensions.openweather \
        unit 'celsius'
    gsettings set org.gnome.shell.extensions.openweather \
        wind-speed-unit 'kph'
    gsettings set org.gnome.shell.extensions.openweather \
        city '48.1371079,11.5753822>München, OB, Bayern, Deutschland >-1'
    # theme
    gsettings set org.gnome.shell.extensions.user-theme \
        name 'Arc-Dark'
    # enable extensions
    gsettings set org.gnome.shell enabled-extensions \
        "['alternate-tab@gnome-shell-extensions.gcampax.github.com', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'dash-to-dock@micxgx.gmail.com', 'openweather-extension@jenslody.de', 'TopIcons@phocean.net', 'nohotcorner@azuri.free.fr']"

    echo 'Setting keyboard shortcuts'
    gsettings set org.gnome.desktop.input-sources \
        xkb-options "['caps:ctrl_modifier', 'compose:ralt']"
    gsettings set org.gnome.desktop.wm.keybindings \
        switch-input-source "[]"
    gsettings set org.gnome.desktop.wm.keybindings \
        switch-input-source-backward "[]"
    kb_sch='org.gnome.settings-daemon.plugins.media-keys.custom-keybinding'
    kb_dir='/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings'
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
        "['$kb_dir/custom0/', '$kb_dir/custom1/', '$kb_dir/custom2/', '$kb_dir/custom3/', '$kb_dir/custom4/', '$kb_dir/custom5/']"
    gsettings set $kb_sch:$kb_dir/custom0/ name 'Nautilus'
    gsettings set $kb_sch:$kb_dir/custom0/ command 'nautilus'
    gsettings set $kb_sch:$kb_dir/custom0/ binding '<Super>e'
    gsettings set $kb_sch:$kb_dir/custom1/ name 'Rofi run'
    gsettings set $kb_sch:$kb_dir/custom1/ command 'rofi -show run'
    gsettings set $kb_sch:$kb_dir/custom1/ binding '<Super>space'
    gsettings set $kb_sch:$kb_dir/custom2/ name 'Rofi window'
    gsettings set $kb_sch:$kb_dir/custom2/ command 'rofi -show window'
    gsettings set $kb_sch:$kb_dir/custom2/ binding 'F10'
    gsettings set $kb_sch:$kb_dir/custom3/ name 'Rofi ssh'
    gsettings set $kb_sch:$kb_dir/custom3/ command 'rofi -show ssh'
    gsettings set $kb_sch:$kb_dir/custom3/ binding 'F9'
    gsettings set $kb_sch:$kb_dir/custom4/ name 'Rofi pass'
    gsettings set $kb_sch:$kb_dir/custom4/ command 'rofi-pass --last-used'
    gsettings set $kb_sch:$kb_dir/custom4/ binding 'F8'
    gsettings set $kb_sch:$kb_dir/custom5/ name 'Tmux'
    gsettings set $kb_sch:$kb_dir/custom5/ \
        command 'urxvt -e tmux new-session -A -s tmux'
    gsettings set $kb_sch:$kb_dir/custom5/ binding '<Super>Return'

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

fi

echo 'Creating symlinks'
bash ./symlinks.sh >/dev/null

popd >/dev/null

echo 'Installing Vim-Plugins'
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

echo 'Generating Tmuxline'
vim +'Tmuxline airline' +'TmuxlineSnapshot! ~/.tmux/tmuxline.conf' +qall
tmux source-file ~/.tmux.conf

echo 'Setting fish as default shell'
sudo chsh -s "$(grep /fish$ /etc/shells | tail -1)" "$USER"

echo 'Setting urxvt as default terminal'
sudo update-alternatives --set x-terminal-emulator "$(which urxvt)"

echo 'Installing tmux plugins'
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

echo 'Setting up ranger'
ranger --copy-config=scope

echo 'Setting up mail sync'
mkdir "$HOME/Mail"
SYNC="users | grep $USER >/dev/null && $HOME/.bin/mailsync.sh"
CRON="*/15 * * * * $SYNC"
crontab -l 2>/dev/null \
    | fgrep -i -v "$SYNC" \
    | { cat; echo "$CRON"; } \
    | crontab -

echo 'Making Vim the default editor'
mimeapps=$HOME/.local/share/applications/mimeapps.list
mimehead="[Default Applications]"
if [[ ! -f $mimeapps ]]; then
    rm -rf "$mimeapps"
    touch "$mimeapps"
fi
if grep -vq "$mimehead" "$mimeapps"; then
    echo "$mimehead" > "$mimeapps"
fi
grep gedit\.desktop "/usr/share/applications/defaults.list" \
    | sed 's/gedit\.desktop/vim.desktop/' \
    >> "$mimeapps"


echo 'Making zathura the default pdf viewer'
mimeapps=$HOME/.local/share/applications/mimeapps.list
grep evince\.desktop "/usr/share/applications/defaults.list" \
    | sed 's/evince\.desktop/zathura.desktop/' \
    >> "$mimeapps"
