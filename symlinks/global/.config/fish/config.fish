# Map Control_L to Shift_L + F12 (for tmux prefix)
pgrep -u $USER xcape > /dev/null; or xcape -e 'Control_L=Shift_L|F12'

# Vim is the standard text editor.
set -x EDITOR vim

# jenv
set PATH $HOME/.jenv/bin $PATH

# rbenv
set PATH $HOME/.rbenv/bin $PATH
status --is-interactive; and . (rbenv init - | sed 's/setenv/set -gx/' | psub)
fix_path

# rust
set PATH $HOME/.cargo/bin $PATH

# abbreviations
if not set -q __abbr_init
  set -gx __abbr_init
  source $HOME/.config/fish/abbr.fish
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
