function dockerclean
    set -l usage "Usage: dockerclean"
    set -l desc "Removes all unused Docker data (containers, images, networks, build cache, volumes) forcefully."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    echo "Cleaning up all unused Docker data (containers, images, networks, build cache, volumes)..."

    docker system prune -af --volumes
    if test $status -ne 0
        echo "An error occurred during Docker system prune." >&2
        return 1
    end
    echo "Docker system clean-up complete."
end

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