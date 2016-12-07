function ssh
    if test (count $argv) -eq 1 -a $TERM = "rxvt-unicode-256color"
        command ssh -t $argv[1] 'TERM=screen; $SHELL'
    else
        command ssh $argv
    end
end
