function ga
    set -g __ga_target (git config ga.workspace | envsubst)
    set -g __ga_others (git config ga.others | sed -e 's/,\s*/\n/g' | envsubst)

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
    for l in $__ga_target"/"(ls $__ga_target) $__ga_others
        pushd $l
        if set -l out (git status ^ /dev/null)
            set branch (echo $out | grep -ioe 'on branch [^ ]*' | sed -E 's/.*h ([^ ]*)/\1/')
            set dir (__fish.ga.dirname $l)
            echo -s $__ga_g $dir " (" $__ga_y $branch $__ga_n ")"
            git fetch --all
            echo ""
        end
        popd
    end
end

function __fish.ga.status
    for l in $__ga_target"/"(ls $__ga_target) $__ga_others
        pushd $l
        if set -l out (git status ^ /dev/null)
            set branch (echo $out | grep -ioe 'on branch [^ ]*' | sed -E 's/.*h ([^ ]*)/\1/')
            set dir (__fish.ga.dirname $l)
            echo -s $__ga_g $dir " (" $__ga_y $branch $__ga_n ")"
            tput setaf 1
            echo $out | grep -ioe "Untracked files\|Changes not staged\|Your branch is behind\|Your branch is ahead" | head -1
            tput sgr0
            echo $out | grep -ioe "nothing to commit" | head -1
            echo ""
        end
        popd
    end
end

function __fish.ga.dirname
    set -l realhome ~
    echo $argv | sed -e "s|^$realhome|~|" -e 's-\([^/.]\)[^/]*/-\1/-g'
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
