set target ~/workspace
function ga
    if count $argv > /dev/null
        switch $argv
        case 'p'
            __fish.ga.pull
        case 's'
            __fish.ga.status
        end
    else
        __fish.ga.status
    end
end

function __fish.ga.pull
    for l in (ls $target)
        pushd $target/$l
        git pull
        popd
    end
end

function __fish.ga.status
    uncommitted $target
end

# completion
function __fish.ga.no_subcommand --description 'Test if ga has yet to be given the subcommand'
    for i in (commandline -opc)
        if contains -- $i p s
            return 1
        end
    end
    return 0
end

complete -f -n '__fish.ga.no_subcommand' -c ga -a 'p' --description "pull"
complete -f -n '__fish.ga.no_subcommand' -c ga -a 's' --description "status"
