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

    echo 'Installing rbenv'
    git clone https://github.com/rbenv/rbenv \
        "$HOME/.rbenv" >/dev/null
    pushd "$HOME/.rbenv" >/dev/null
    src/configure
    make -C src
    mkdir -p plugins
    git clone https://github.com/rbenv/ruby-build.git \
        plugins/ruby-build
    popd >/dev/null

    echo 'Installing gems'
    sudo gem install \
        gem-shut-the-fuck-up bundler git-amnesia git-rc >/dev/null

    echo 'Installing docker-compose'
    tmp="$(mktemp)"
    curl -L \
        "https://github.com/docker/compose/releases/download/1.12.0/docker-compose-$( \
        uname -s)-$(uname -m)" \
        > "$tmp" 2>/dev/null
    sudo mkdir -p /usr/local/bin
    sudo mv "$tmp" /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo adduser "$USER" docker
fi

echo 'Installing git-lfs'
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
# begin quickfix
sudo sed -i 's/artful/zesty/' /etc/apt/sources.list.d/github_git-lfs.list
sudo apt update
# end quickfix
sudo apt install git-lfs
git lfs install

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
    fontUrl="https://github.com/ryanoasis/nerd-fonts/raw/1.0.0/patched-fonts"
    mkdir -p "$HOME/.local/share/fonts"
    pushd "$HOME/.local/share/fonts" >/dev/null
    wget -q \
        "$fontUrl/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf"
    wget -q \
        "$fontUrl/FiraCode/Regular/complete/Fura%20Code%20Regular%20Nerd%20Font%20Complete.otf"
    wget -q \
        "$fontUrl/FiraMono/Regular/complete/Fura%20Mono%20Regular%20for%20Powerline%20Nerd%20Font%20Complete.otf"
    wget -q \
        "https://github.com/adobe-fonts/source-code-pro/raw/release/OTF/SourceCodePro-Regular.otf"
    wget -q \
        "https://github.com/tonsky/FiraCode/raw/master/distr/otf/FiraCode-Regular.otf"
    wget -q \
        "https://github.com/mozilla/Fira/raw/master/otf/FiraMono-Regular.otf"
    popd >/dev/null

    echo 'Installing mutt dependencies'
    sudo pip install mutt_ics vobject
    sudo pip install gcalcli

    echo 'Setting chromium as default browser'
    sudo update-alternatives --set gnome-www-browser "$(which chromium-browser)"
    sudo update-alternatives --set x-www-browser "$(which chromium-browser)"
fi

if [[ $DESKTOP_SESSION = gnome ]]; then
    echo 'Remove Ubuntus ugly gdm config'
    sudo update-alternatives --set gdm3.css \
        /usr/share/gnome-shell/themes/gnome-shell.css

    echo 'Installing gnome-shell extensions'
    gnomeshell_install="$HOME/.dotfiles/bin.symlink/gnomeshell-extension-manage \
        --install --extension-id"
    # user themes
    $gnomeshell_install 19
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
    gsettings set org.gnome.desktop.input-sources xkb-options \
        "['caps:ctrl_modifier', 'compose:ralt', 'shift:both_capslock_cancel']"
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
        command "konsole -e 'tmux new-session -A -s tmux'"
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
    gsettings set org.gnome.desktop.background picture-uri \
        'file:///usr/share/backgrounds/ubuntu-gnome/sochi_krasnaya_polyana_mountains_by_alexander_lyubavin.jpg'
    gsettings set org.gnome.desktop.screensaver picture-uri \
        'file:///usr/share/backgrounds/ubuntu-gnome/sochi_krasnaya_polyana_mountains_by_alexander_lyubavin.jpg'

fi

echo 'Creating symlinks'
bash ./symlinks.sh >/dev/null

popd >/dev/null

echo 'Installing Vim-Plugins'
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

# echo 'Generating Tmuxline'
# vim +'Tmuxline airline' +'TmuxlineSnapshot! ~/.tmux/tmuxline.conf' +qall
# tmux source-file ~/.tmux.conf

echo 'Setting fish as default shell'
sudo chsh -s "$(grep /fish$ /etc/shells | tail -1)" "$USER"

echo 'Installing omf'
tmp="$(mktemp)"
curl -L https://get.oh-my.fish > "$tmp"
fish "$tmp" --noninteractive --yes
echo "omf install" | fish
rm -rf "$tmp"

echo 'Setting Konsole as default terminal'
sudo update-alternatives --set x-terminal-emulator "$(which konsole)"

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
