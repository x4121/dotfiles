set -x target ~/workspace
set -x others ~/.dotfiles

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
    for l in $target"/"(ls $target) $others
        pushd $l
        if set -l out (git status ^ /dev/null)
            echo $l
            echo $out | grep -ioe " branch [^ ]*" | head -1 | sed "s/h /h: /"
            git pull
        end
        popd
    end
end

function __fish.ga.status
    for l in $target"/"(ls $target) $others
        pushd $l
        if set -l out (git status ^ /dev/null)
            echo $l
            echo $out | grep -ioe " branch [^ ]*" | head -1 | sed "s/h /h: /"
            tput setaf 1
            echo $out | grep -ioe " Untracked files\| Changes not staged" | head -1
            tput sgr0
            echo $out | grep -ioe " nothing to commit" | head -1
        end
        popd
    end
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
