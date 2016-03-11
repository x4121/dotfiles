set -x task (which task)

function task
    # never synced
    if not set -q __task_last_sync
        __task.sync
    # last sync > 5 min ago
    else if math (date +%s) - $__task_last_sync " > 300" > /dev/null
        __task.sync
    end
    eval $task $argv
end

function __task.sync
    set -g __task_last_sync (date +%s)
    eval $task sync
end
