# remove greeting message
set -e fish_greeting

# Map Control_L to Shift_L + F12 (for tmux prefix)
pgrep -u $USER xcape > /dev/null; or xcape -e 'Control_L=Shift_L|F12'

# Vim is the standard text editor.
set -x EDITOR vim

# jenv
set PATH $HOME/.jenv/bin $PATH

# rbenv
rbenv rehash > /dev/null ^&1

# aliases
alias gpg gpg2

# solarized man pages
set -x LESS_TERMCAP_mb (printf "\033[01;31m") # begin blinking
set -x LESS_TERMCAP_md (printf "\033[01;38;5;74m") # begin bold
set -x LESS_TERMCAP_me (printf "\033[0m") # end mode
set -x LESS_TERMCAP_se (printf "\033[0m") # end standout-mode
set -x LESS_TERMCAP_so (printf "\033[38;5;246m") # begin standout-mode - info box
set -x LESS_TERMCAP_ue (printf "\033[0m") # end underline
set -x LESS_TERMCAP_us (printf "\033[04;38;5;146m") # begin underline

# gnome-keyring
eval (echo (gnome-keyring-daemon -s) | sed -e 's/^\(.*\)/set -x \\1/' -e 's/=/ /' -e 's/\(.*\)$/\1;/')
