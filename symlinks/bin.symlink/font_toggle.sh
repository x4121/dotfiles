#!/bin/bash

wid=$(env | grep WINDOWID | grep -o '[[:digit:]]*')
file="/tmp/font_state_${wid}"
default='Font="FuraMonoForPowerline Nerd Font"'
code='Font="FuraCode Nerd Font"'

konsoleprofile-set() {
    if [[ -z $TMUX ]]; then
        konsoleprofile "$1"
    else
        printf '\033Ptmux;\033\033]50;%s\007\033\\' "$1"
    fi
}

if [[ -f $file ]]; then
    konsoleprofile-set "$code"
    # konsoleprofile-set 'LineSpacing=2'
    rm "$file"
else
    echo "1" > "$file"
    konsoleprofile-set "$default"
    # konsoleprofile-set 'LineSpacing=0'
fi
