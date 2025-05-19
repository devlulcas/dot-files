function psgrep
    set -l usage "Usage: psgrep <process-name>"
    set -l desc "Searches for a process by name using a case-insensitive match."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    set search_term (string join '.*' $argv)
    ps aux | grep -i $search_term | grep -v grep
end

function pslistening
    set -l usage "Usage: pslistening <port-number>"
    set -l desc "Finds the process listening on a specified TCP port."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

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