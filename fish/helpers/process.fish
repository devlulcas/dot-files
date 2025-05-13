function psgrep
    if test (count $argv) -eq 0
        echo "Usage: psgrep <process-name>"
        return 1
    end
    set search_term (string join '.*' $argv)
    ps aux | grep -i $search_term | grep -v grep
end

function pslistening --description "Find the process listening on a specified port"
    if test (count $argv) -ne 1
        echo "Usage: process_on_port <port-number>"
        echo "Example: process_on_port 8080"
        return 1
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