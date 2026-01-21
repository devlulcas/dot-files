#!/usr/bin/env fish

set -l psx_desc "Process search utility."
function psx --description $psx_desc
    argparse 'h/help' 's/search=' 'p/port=' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="psx" \
            --description=$psx_desc \
            --opt="s/search Search for a process by name using a case-insensitive match." \
            --opt="p/port Find the process listening on a specified TCP port."
        return
    end

    if set -ql _flag_search
        __search $_flag_search
    end

    if set -ql _flag_port
        __listening $_flag_port
    end
end

function __search
    set search_term (string join '.*' $argv)
    ps aux | grep -i $search_term | grep -v grep
end

function __listening
    set port $argv[1]

    echo "Searching for process on port $port..."

    # Use lsof if available
    if type -q lsof
        lsof -i tcp:$port -s tcp:listen
        # Otherwise, try ss (more common on newer Linux systems)
    else if type -q ss
        ss -tulnp | grep ":$port\>"
        # Fallback to netstat (older systems)
    else if type -q netstat
        netstat -tulnp | grep ":$port\>"
    else
        echo "Neither lsof, ss, nor netstat found. Cannot check for processes."
        return 1
    end

    if test $status -ne 0
        echo "No process found listening on port $port."
    end
end
