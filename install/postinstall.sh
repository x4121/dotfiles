#!/bin/bash
set -e

if ! [[ -z ${I_DEV+x} ]]; then
    echo 'Installing asdf'

    sudo apt-get install -y \
        libssl-dev libncurses5-dev libreadline-dev zlib1g-dev >/dev/null
    git clone https://github.com/asdf-vm/asdf.git \
        "$HOME/.asdf" --branch v0.5.1 >/dev/null
    mkdir -p "$HOME/.config/fish/completions"
    cp "$HOME/.asdf/completions/asdf.fish" "$HOME/.config/fish/completions"

    # shellcheck disable=SC1090
    source "$HOME/.asdf/asdf.sh"
    asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
    asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
    asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby
    asdf plugin-add java https://github.com/skotchpine/asdf-java
    asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs

    asdf install erlang 21.0.5
    asdf global erlang 21.0.5
    asdf install elixir 1.7.2-otp-21
    asdf global elixir 1.7.2-otp-21
    asdf install ruby 2.5.1
    asdf global ruby 2.5.1
    asdf install nodejs 10.11.0
    asdf global nodejs 10.11.0

    echo 'Installing rust'
    curl https://sh.rustup.rs -sSf | sh >/dev/null
    # shellcheck disable=SC1090
    source "$HOME/.cargo/env"
    cargo install cargo-deb

    echo 'Installing phoenix'
    mix local.hex --force
    mix local.rebar --force
    mix archive.install --force \
        https://github.com/phoenixframework/archives/raw/master/phx_new.ez

    echo 'Installing gems'
    gem install \
        gem-shut-the-fuck-up bundler git-amnesia >/dev/null

    echo 'Installing docker-compose'
    tmp="$(mktemp)"
    curl -L \
        "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$( \
        uname -s)-$(uname -m)" \
        > "$tmp" 2>/dev/null
    sudo mkdir -p /usr/local/bin
    sudo mv "$tmp" /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo adduser "$USER" docker

    echo 'Installing scalafmt'
    tmp="$(mktemp -d)"
    pushd "$tmp" >/dev/null
    curl -L -o coursier https://git.io/vgvpD 2>/dev/null
    chmod +x coursier
    sudo ./coursier bootstrap com.geirsson:scalafmt-cli_2.12:1.3.0 \
        -o /usr/local/bin/scalafmt --standalone --main org.scalafmt.cli.Cli
    popd >/dev/null
    rm -rf "$tmp"

    echo 'Installing git-lfs'
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
    sudo apt install git-lfs
    git lfs install

    echo 'Installing pre-commit'
    pip install pre-commit

    echo 'Installing terraform-docs'
    go get github.com/segmentio/terraform-docs
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
    sudo pip install awscli

    echo 'Setting chromium as default browser'
    sudo update-alternatives --set gnome-www-browser "$(which chromium-browser)"
    sudo update-alternatives --set x-www-browser "$(which chromium-browser)"

    echo 'Installing tdrop'
    tmp=$(mktemp -d)
    git clone https://github.com/noctuid/tdrop "$tmp" >/dev/null
    pushd "$tmp" >/dev/null
    sudo make install >/dev/null
    popd >/dev/null
    rm -rf "$tmp"
fi

if [[ $DESKTOP_SESSION = gnome ]]; then
    echo "Remove Ubuntu's ugly gdm/plymouth config"
    sudo update-alternatives --set gdm3.css \
        /usr/share/gnome-shell/theme/gnome-shell.css
    sudo update-alternatives --set default.plymouth \
        /usr/share/plymouth/themes/ubuntu-gnome-logo/ubuntu-gnome-logo.plymouth

    echo 'Installing gnome-shell extensions'
    gnomeshell_install="$HOME/.dotfiles/symlinks/bin.symlink/gnomeshell-extension-manage \
        --install --version latest --extension-id"
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
    # sound io chooser
    $gnomeshell_install 906
    # openweather
    $gnomeshell_install 750

    echo 'Configuring gnome-shell extensions'
    ext_home="$HOME/.local/share/gnome-shell/extensions"
    schema_dir=/usr/share/glib-2.0/schemas/
    sudo cp \
        "$ext_home/user-theme@gnome-shell-extensions.gcampax.github.com/schemas/org.gnome.shell.extensions.user-theme.gschema.xml" \
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

    kb_list='['
    for i in $(seq 0 9); do
        kb_list="$kb_list'$kb_dir/custom$i/', "
    done
    kb_list="${kb_list/%, /]}"
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
        "$kb_list"
    gsettings set $kb_sch:$kb_dir/custom0/ name 'Nautilus'
    gsettings set $kb_sch:$kb_dir/custom0/ command 'nautilus'
    gsettings set $kb_sch:$kb_dir/custom0/ binding '<Super>e'
    gsettings set $kb_sch:$kb_dir/custom1/ name 'Rofi run'
    gsettings set $kb_sch:$kb_dir/custom1/ command 'rofi -show run'
    gsettings set $kb_sch:$kb_dir/custom1/ binding '<Super>space'
    gsettings set $kb_sch:$kb_dir/custom2/ name 'Rofi window'
    gsettings set $kb_sch:$kb_dir/custom2/ command 'rofi -show window'
    gsettings set $kb_sch:$kb_dir/custom2/ binding 'F10'
    gsettings set $kb_sch:$kb_dir/custom3/ name 'Rofi soundboard'
    gsettings set $kb_sch:$kb_dir/custom3/ command "$HOME/.dotfiles/etc/rofi-soundboard/rofi-soundboard"
    gsettings set $kb_sch:$kb_dir/custom3/ binding 'F9'
    gsettings set $kb_sch:$kb_dir/custom4/ name 'Rofi pass'
    gsettings set $kb_sch:$kb_dir/custom4/ command 'rofi-pass --last-used'
    gsettings set $kb_sch:$kb_dir/custom4/ binding 'F8'
    gsettings set $kb_sch:$kb_dir/custom5/ name 'Tmux'
    gsettings set $kb_sch:$kb_dir/custom5/ \
        command "alacritty -e tmux new-session -A -s tmux"
    gsettings set $kb_sch:$kb_dir/custom5/ binding '<Super>Return'
    gsettings set $kb_sch:$kb_dir/custom6/ name 'Dropdown'
    # shellcheck disable=SC2016
    gsettings set $kb_sch:$kb_dir/custom6/ \
        command 'tdrop -m -h 34%% -y 0 -s dropdown -f "--config-file $HOME/.config/alacritty/dropdown.yml" alacritty'
    gsettings set $kb_sch:$kb_dir/custom6/ binding 'F12'
    gsettings set $kb_sch:$kb_dir/custom7/ name 'dnd-toggle'
    gsettings set $kb_sch:$kb_dir/custom7/ command 'dnd-toggle'
    gsettings set $kb_sch:$kb_dir/custom7/ binding '<Super>z'

    gsettings set $kb_sch:$kb_dir/custom8/ name 'System Monitor'
    gsettings set $kb_sch:$kb_dir/custom8/ command 'gnome-system-monitor'
    gsettings set $kb_sch:$kb_dir/custom8/ binding '<Primary><Shift>Escape'
    gsettings set $kb_sch:$kb_dir/custom9/ name 'xkill'
    gsettings set $kb_sch:$kb_dir/custom9/ command 'xkill'
    gsettings set $kb_sch:$kb_dir/custom9/ binding '<Super>k'

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

    echo 'Force disabling Wayland'
    sudo sed -i 's/^#\(WaylandEnable=false\)/\1/' /etc/gdm3/custom.conf
fi

echo 'Creating symlinks'
bash ./symlinks.sh >/dev/null

popd >/dev/null

echo 'Installing Vim-Plugins'
curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

echo 'Setting fish as default shell'
sudo chsh -s "$(grep /fish$ /etc/shells | tail -1)" "$USER"

echo 'Installing omf'
tmp="$(mktemp)"
curl -L https://get.oh-my.fish > "$tmp"
fish "$tmp" --noninteractive --yes
echo "omf install" | fish
rm -rf "$tmp"

echo 'Installing alacritty'
sudo apt-get install -y \
    pkg-config freetype6-dev libfontconfig1-dev >/dev/null
tmp="$(mktemp -d)"
git clone https://github.com/jwilm/alacritty "$tmp" >/dev/null
( cd "$tmp"; cargo deb --install )
rm -rf "$tmp"

echo 'Setting alacritty as default terminal'
# sudo update-alternatives --set x-terminal-emulator "$(which alacritty)"
sudo update-alternatives --install \
    /etc/alternatives/x-terminal-emulator \
    x-terminal-emulator \
    "$(which alacritty)" \
    1000
sudo ln -sf /etc/alternatives/x-terminal-emulator /usr/bin/x-terminal-emulator

echo "Installing bat"
tmp="$(mktemp -d)"
git clone https://github.com/sharkdp/bat "$tmp" >/dev/null
( cd "$tmp"; cargo deb --install )
rm -rf "$tmp"
bat cache --init

echo 'Installing tmux plugins'
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

echo 'Setting up ranger'
ranger --copy-config=scope

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

echo 'Enabling mail sync'
mkdir -p "$HOME/Mail/armingrodon.de"
mkdir -p "$HOME/Mail/gmail.com"
mkdir -p "$HOME/Mail/ryte.com"
systemctl --user enable mbsync.timer
systemctl --user start mbsync.timer

echo 'Making zathura the default pdf viewer'
mimeapps=$HOME/.local/share/applications/mimeapps.list
grep evince\.desktop "/usr/share/applications/defaults.list" \
    | sed 's/evince\.desktop/zathura.desktop/' \
    >> "$mimeapps"
