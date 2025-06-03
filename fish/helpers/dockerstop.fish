function dockerstop
    set -l usage "Usage: dockerstop"
    set -l desc "Stops all running Docker containers."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    echo "Stopping all running Docker containers..."
    set running_containers (docker ps -q)

    if test (count $running_containers) -eq 0
        echo "No running containers found."
        return 0
    end

    docker stop $running_containers
    if test $status -ne 0
        echo "An error occurred while trying to stop containers." >&2
        return 1
    end
    echo "All running Docker containers stopped."
end