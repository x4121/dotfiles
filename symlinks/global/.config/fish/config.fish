set PATH $HOME/.bin $HOME/.local/bin $HOME/.cargo/bin $PATH

# Launch starship
starship init fish | source

# Keep default to vim, so we don't edit passwords in neovim
set -x EDITOR vim

set -x BAT_THEME gruvbox-dark

set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket

# zoxide
zoxide init fish | source

# allow pass-tessen
set -x PASSWORD_STORE_ENABLE_EXTENSIONS true

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
