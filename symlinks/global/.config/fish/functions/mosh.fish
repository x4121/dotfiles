function mosh
    if test (count $argv) -eq 1
        command mosh --no-init $argv -- sh -c 'tmux new-session -A -s $(hostname -s) 2>/dev/null || $SHELL'
    else
        command mosh $argv
    end
end
