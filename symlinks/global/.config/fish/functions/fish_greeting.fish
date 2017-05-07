# print available sessions if attached to none
function fish_greeting
    if tmux -V >/dev/null ^/dev/null; and not test $TMUX
        tmux ls
    end
end
