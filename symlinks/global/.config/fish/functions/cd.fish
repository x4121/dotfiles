function cd
    if test (count $argv) -eq 0
        builtin cd
    else
        while count $argv > /dev/null
            builtin cd $argv[1]
            set -e argv[1]
        end
        echo "clearing status" > /dev/null
    end
end

complete -c cd -a "(__cd_complete)"

function __cd_complete
    set cmd (commandline -opc)
    if test (count $cmd) -gt 1
        find (echo $cmd[2..-1] | sed 's/ /\//g') -maxdepth 1 -type d -not -name '.*' -exec basename '{}' \;
    end
end
