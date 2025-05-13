function dockerclean --description "Removes all unused Docker data (containers, images, volumes, etc.) forcefully"
    echo "Cleaning up all unused Docker data (containers, images, networks, build cache, volumes)..."
    docker system prune -af --volumes
    if test $status -ne 0
        echo "An error occurred during Docker system prune." >&2
        return 1
    end
    echo "Docker system clean-up complete."
end

function dockerstop --description "Stops all running Docker containers"
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