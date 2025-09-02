#!/usr/bin/env fish

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
