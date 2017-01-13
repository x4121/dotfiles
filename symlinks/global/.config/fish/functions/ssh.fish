function ssh
    if test (count $argv) -eq 1
        command ssh -t $argv 'sh -c \'tmux new-session -A -s $(hostname -s) 2>/dev/null || $SHELL\''
    else
        command ssh $argv
    end
end
