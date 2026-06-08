#!/usr/bin/env fish

set -l killport_desc "Kills a process listening on a specified TCP port."
function killport --description $killport_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="killport <port>" \
            --description=$killport_desc \
            --dependency="lsof" \
            --dependency="kill" \
            --opt="p/port Kill the process listening on a specified TCP port." \
            --example="killport 3000"
        return
    end

    __require_arg "port" "$argv[1]" or return
    __require_numeric_port "$argv[1]" or return
    __require_command lsof or return

    set -l port $argv[1]

    echo "Checking for process on port $port..."

    set -l icon /usr/share/icons/Adwaita/symbolic/actions/process-stop-symbolic.svg

    set -l process_pid (lsof -ti tcp:$port -s tcp:listen)

    if test (count $process_pid) -eq 0
        echo "No process found listening on port $port."
        return 1
    end

    echo "Killing process "(string join ", " $process_pid)" listening on port $port..."
    kill -9 $process_pid
    if test $status -ne 0
        __error "Error killing process listening on port $port."
        return 1
    end
    echo "Process "(string join ", " $process_pid)" listening on port $port killed."

    if command -q notify-send
        notify-send -i $icon -a "Kill Port" "Port $port killed!" "The process '"(string join ", " $process_pid)"' was killed."
    end
end
