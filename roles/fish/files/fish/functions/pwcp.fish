function pwcp
    if test (count $argv) -eq 0
        pwgen -Bcn 20 1 | xargs echo -n | xsel -ib
    else
        pwgen -Bcn $argv[1] 1 | xargs echo -n | xsel -ib
    end
end

