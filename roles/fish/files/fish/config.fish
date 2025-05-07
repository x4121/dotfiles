set PATH $HOME/.bin $HOME/.local/bin $PATH

# dotfiles
set -x DOTFILES $HOME/workspace/ansible-dots

# rust
set -x RUSTUP_HOME /opt/rustup
set -x CARGO_HOME /opt/cargo
set PATH $CARGO_HOME/bin $PATH

# Launch starship
starship init fish | source

# Vi is the standard text editor.
# Keep default to vi, so we don't edit passwords in neovim
set -x EDITOR vi

set -x BAT_THEME gruvbox-dark

# asdf
test -f $HOME/.asdf/asdf.fish; and source $HOME/.asdf/asdf.fish

# zoxide
zoxide init fish | source

# granted
alias assume="source /usr/local/bin/assume.fish"
set -x GRANTED_ALIAS_CONFIGURED true

# abbreviations
source $HOME/.config/fish/abbr.fish

# aliases
source $HOME/.config/fish/alias.fish

# colored man pages
set -x LESS_TERMCAP_mb (printf '\e[01;31m') # enter blinking mode - red
set -x LESS_TERMCAP_md (printf '\e[01;35m') # enter double-bright mode - bold, magenta
set -x LESS_TERMCAP_me (printf '\e[0m') # turn off all appearance modes (mb, md, so, us)
set -x LESS_TERMCAP_se (printf '\e[0m') # leave standout mode
set -x LESS_TERMCAP_so (printf '\e[01;33m') # enter standout mode - yellow
set -x LESS_TERMCAP_ue (printf '\e[0m') # leave underline mode
set -x LESS_TERMCAP_us (printf '\e[04;36m') # enter underline mode - cyan
