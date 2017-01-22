function ccd --description "ccd [-pmZ] <directory>: mkdir and cd"
    set -e parents
    set -e Z
    set -e mode
    set -e folder
    if count $argv > /dev/null
        while count $argv > /dev/null
            switch $argv[1]
                case '-p' '--parents'
                    set parents '-p'
                case '-Z'
                    set Z '-Z'
                case '-m' '--mode'
                    set -e argv[1]
                    set mode '-m '$argv[1]
                case '-m=*' '--mode=*'
                    set mode $argv[1]
                case '-h' '--help'
                    __ccd.usage
                    return 0
                case '-*'
                    __ccd.usage
                    return 1
                case '*'
                    if set -q folder
                        __ccd.folder_isset
                        return 1
                    else
                        set folder $argv[1]
                    end
            end
            set -e argv[1]
        end
        if set -q folder
            if mkdir $Z $mode $parents $folder
                cd $folder
            end
        else
            __ccd.folder_missing
            return 1
        end
    end
end

function __ccd.usage
    echo 'Usage: ccd [OPTIONS]... DIRECTORY'
    echo 'Create the DIRECTORY and change into them.'
    echo ''
    echo 'Mandatory arguments to long options are mandatory for short options too.'
    echo '  -m, --mode=MODE   set file mode (as in chmod), not a=rwx - umask'
    echo '  -p, --parents     no error if existing, make parent directories as needed'
    echo '  -Z                set SELinux security context of each created directory'
    echo '                    to the default type'
    echo '      --help        display this help and exit'
end

function __ccd.folder_isset
    echo 'ccd: only one folder expected'
    echo 'Try \'ccd --help\' for more information'
end

function __ccd.folder_missing
    echo 'ccd: missing operand <folder>'
    echo 'Try \'ccd --help\' for more information'
end

complete -c ccd -s p -l parents --description 'no error if existing, make parents directories as needed.'
complete -c ccd -s m -l mode --description 'set file mode (as in chmod), not a=rwx - umask'
complete -c ccd -s Z --description 'set SELinux security context of each created directory to the default type'
complete -c ccd -s h -l help --description 'display this help and exit.'
