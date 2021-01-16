function gall
    set -g __ga_target (git config dir.workspace | envsubst)
    set -g __ga_others (git config dir.others | sed -e 's/:\s*/\n/g' | envsubst)

    set -g __ga_g (set_color green)
    set -g __ga_y (set_color yellow)
    set -g __ga_n (set_color normal)

    if count $argv > /dev/null
        switch $argv
        case '-f' '--fetch'
            __fish.ga.fetch
        case '-s' '--status'
            __fish.ga.status
        end
    else
        __fish.ga.status
    end
end

function __fish.ga.fetch
    for l in (find $__ga_target -mindepth 1 -maxdepth 1 -type d) $__ga_others
        pushd $l
        echo -s (starship module directory) (starship module git_branch) (starship module git_status)
        git fetch --all
        echo ""
        popd
    end
end

function __fish.ga.status
    for l in (find $__ga_target -mindepth 1 -maxdepth 1 -type d) $__ga_others
        pushd $l
        echo -s (starship module directory) (starship module git_branch) (starship module git_status)
        popd
    end
end

# completion
function __fish.ga.no_subcommand --description 'Test if ga has yet to be given the subcommand'
    for i in (commandline -opc)
        if contains -- $i f s
            return 1
        end
    end
    return 0
end

complete -f -n '__fish.ga.no_subcommand' -c ga -s 'f' -l 'fetch' --description "fetch all repos"
complete -f -n '__fish.ga.no_subcommand' -c ga -s 's' -l 'status' --description "status of all repos"
