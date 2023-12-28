set PATH $HOME/.bin $HOME/.local/bin $PATH

# rust
set RUSTUP_HOME /opt/rustup
set CARGO_HOME /opt/cargo
set PATH $CARGO_HOME/bin $PATH

# Launch starship
starship init fish | source

# Vim is the standard text editor.
set -x EDITOR vim

set -x BAT_THEME gruvbox-dark

# asdf
source $HOME/.asdf/asdf.fish

# zoxide
zoxide init fish | source

# coursier
set -x COURSIER_INSTALL_DIR /usr/local/coursier/bin
set PATH /usr/local/coursier/bin $PATH

# abbreviations
if not set -q __abbr_init
  set -gx __abbr_init
  source $HOME/.config/fish/abbr.fish
end

# aliases
if not set -q __alias_init
  set -gx __alias_init
  source $HOME/.config/fish/alias.fish
end

# colored man pages
set -x LESS_TERMCAP_mb (printf '\e[01;31m') # enter blinking mode - red
set -x LESS_TERMCAP_md (printf '\e[01;35m') # enter double-bright mode - bold, magenta
set -x LESS_TERMCAP_me (printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
set -x LESS_TERMCAP_se (printf '\e[0m') # leave standout mode
set -x LESS_TERMCAP_so (printf '\e[01;33m') # enter standout mode - yellow
set -x LESS_TERMCAP_ue (printf '\e[0m') # leave underline mode
set -x LESS_TERMCAP_us (printf '\e[04;36m') # enter underline mode - cyan

# gnome-keyring
eval (echo (gnome-keyring-daemon -s) | sed -e 's/^\(.*\)/set -x \\1/' -e 's/=/ /' -e 's/\(.*\)$/\1;/')
