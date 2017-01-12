function apt --description "Wrapper for apt-{get,cache}"
    if count $argv > /dev/null
        switch $argv[1]
            case '-u' '--update'
                apt-update
            case '-g' '--upgrade'
                apt-upgrade
            case '-f' '--full'
                apt-upgrade-full
            case '-r' '--remove'
                apt-remove $argv[2..-1]
            case '-p' '--purge'
                apt-purge $argv[2..-1]
            case '-c' '--clean'
                apt-clean
            case '-i' '--install'
                apt-install $argv[2..-1]
            case '-s' '--search'
                apt-search $argv[2..-1]
            case '-l' '--show'
                apt-show $argv[2..-1]
            case '*'
                __apt.usage
        end
    else
        __apt.usage
    end
end

function apt-update
    sudo apt-get update
end

function apt-upgrade
    sudo apt-get upgrade
end

function apt-upgrade-full
    sudo apt-get update
    and sudo apt-get -y upgrade
    and sudo apt-get -y dist-upgrade
end

function apt-remove
    sudo apt-get remove -y $argv
end

function apt-purge
    sudo apt-get purge -y $argv
end

function apt-clean
    sudo apt-get -y autoremove
    and sudo apt-get autoclean
end

function apt-install
    sudo apt-get install -y $argv
end

function apt-search
    apt-cache search $argv
end

function apt-show
    apt-cache show $argv
end

function __apt.usage
end

function __apt.no_subcommand --description 'Test if apt has yet to be given the subcommand'
	for i in (commandline -opc)
		if contains -- $i -u --update -g --upgrade -f --full -r --remove -p --purge -c --clean -i --install -s --search -l --show
			return 1
		end
	end
	return 0
end

function __apt.use_package --description 'Test if apt command should have packages as potential completion'
	for i in (commandline -opc)
		if contains -- $i contains -i --install -r --remove -p --purge
			return 0
		end
	end
	return 1
end

complete -c apt -n '__apt.use_package' -a '(__fish_print_packages)' --description 'Package'

complete -f -n '__apt.no_subcommand' -c apt -s u -l update --description 'Update sources'
complete -f -n '__apt.no_subcommand' -c apt -s g -l upgrade --description 'Upgrade or install newest packages'
complete -f -n '__apt.no_subcommand' -c apt -s f -l full --description 'Update, upgrade and distro upgrade'
complete -f -n '__apt.no_subcommand' -c apt -s i -l install --description 'Install one or more packages'
complete -f -n '__apt.no_subcommand' -c apt -s p -l purge --description 'Remove and purge one or more packages'
complete -f -n '__apt.no_subcommand' -c apt -s r -l remove --description 'Remove one or more packages'
complete -f -n '__apt.no_subcommand' -c apt -s c -l clean --description 'Clean local caches and remove unused packages'
complete -c apt -s q -l quiet --description 'Quiet mode'

complete -c apt-install -a '(__fish_print_packages)' --description 'Package'
complete -c apt-remove -a '(__fish_print_packages)' --description 'Package'
complete -c apt-purge -a '(__fish_print_packages)' --description 'Package'
