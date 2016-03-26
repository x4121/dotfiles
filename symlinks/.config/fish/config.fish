# fix delete in st
switch $TERM
    case 'st-*'
        tput smkx
        function st_smkx --on-event fish_postexec
            tput smkx
        end
        function st_rmkx --on-event fish_preexec
            tput rmkx
        end
end

# dircolors
eval (dircolors -c $HOME/.dircolors | sed 's/>&\/dev\/null$//')

# remove greeting message
set -e fish_greeting

# Vim is the standard text editor.
set -x EDITOR vim

# pass config
set -x PASSWORD_STORE_DIR $HOME/ownCloud/pass

# jenv
set PATH $HOME/.jenv/bin $PATH
eval jenv init - > /dev/null 2>&1

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

# terminal colors
. colors.fish
