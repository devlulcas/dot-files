#!/usr/bin/env fish

set -l dockutils_desc "Utility functions for Docker container management"
function dockutils --description $dockutils_desc
    argparse 'h/help' 's/stop' 'c/clean' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="dockutils [--stop|-s] [--clean|-c]" \
            --description=$dockutils_desc \
            --opt="s/stop Stop all running Docker containers." \
            --opt="c/clean Clean up all unused Docker data (containers, images, networks, build cache, volumes)."
        return
    end

    if set -ql _flag_stop
        __stop
        return
    end

    if set -ql _flag_clean
        __clean
        return
    end

    echo "Invalid option: $argv[1]. Use --help for usage information."
    return 1
end

function __stop
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

function __clean
    echo "Cleaning up all unused Docker data (containers, images, networks, build cache, volumes)..."

    docker system prune -af --volumes
    if test $status -ne 0
        echo "An error occurred during Docker system prune." >&2
        return 1
    end
    echo "Docker system clean-up complete."
end
