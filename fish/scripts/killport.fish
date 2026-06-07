#!/usr/bin/env fish

set -l killport_desc "Kills a process listening on a specified TCP port."
function killport --description $killport_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="killport <port>" \
            --description=$killport_desc \
            --opt="p/port Kill the process listening on a specified TCP port."
        return
    end

    set port $argv[1]

    echo "Checking for process on port $port..."

    set -l icon /usr/share/icons/Adwaita/symbolic/actions/process-stop-symbolic.svg

    set -l process_pid (lsof -i tcp:$port -s tcp:listen | awk 'NR==2 {print $2}')

    if test -z $process_pid
        echo "No process found listening on port $port."
        return 1
    end

    echo "Killing process $process_pid listening on port $port..."
    kill -9 $process_pid
    if test $status -ne 0
        echo "Error killing process $process_pid listening on port $port." >&2
        return 1
    end
    echo "Process $process_pid listening on port $port killed."
    notify-send -i $icon -a "Kill Port" "Port $port killed!" "The process '$process_pid' was killed."
end
