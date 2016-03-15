function task
    # initial sync
    if __task.needs_sync
        __task.sync
    end

    __task.exec

    # sync if something changed
    __task.sync > /dev/null ^ /dev/null
end

function __task.sync
    set -g __task_last_sync (date +%s)
    command task sync
end

function __task.exec
    command task $argv
end

function __task.needs_sync
    # never synced
    if not set -q __task_last_sync
        return 0
    # last sync > 5 min ago
    else if math (date +%s) - $__task_last_sync " > 300" > /dev/null
        return 0
    else
        return 1
    end
end
