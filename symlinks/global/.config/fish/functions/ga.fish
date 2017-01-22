function ga
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
        case '-t'
            __fish.ga.test
        end
    else
        __fish.ga.status
    end
end

function __fish.ga.fetch
    for l in $__ga_target"/"(ls $__ga_target) $__ga_others
        pushd $l
        if set -l out (git status -s ^ /dev/null)
            set branch (echo $out | grep -ioe "##.*" | sed -E 's/^## ([^.]*).*/\1/')
            set dir (__fish.ga.dirname $l)
            echo -s $__ga_g $dir $__ga_n " (" $__ga_y $branch $__ga_n ")"
            git fetch --all
            echo ""
        end
        popd
    end
end

function __fish.ga.status
    for l in $__ga_target"/"(ls $__ga_target) $__ga_others
        pushd $l
        if git status -s > /dev/null ^ /dev/null
            set dir (__fish.ga.dirname $l)
            echo -s $__fish_prompt_cwd $dir $__fish_prompt_normal (__fish_git_prompt)
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
