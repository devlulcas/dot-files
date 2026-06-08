#!/usr/bin/env fish

set -l dockutils_desc "Utility functions for Docker container management"
function dockutils --description $dockutils_desc
    argparse 'h/help' 's/stop' 'c/clean' 'y/yes' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="dockutils [--stop|-s] [--clean|-c] [--yes|-y]" \
            --description=$dockutils_desc \
            --dependency="docker" \
            --opt="s/stop Stop all running Docker containers." \
            --opt="c/clean Clean up all unused Docker data (containers, images, networks, build cache, volumes)." \
            --opt="y/yes Skip confirmation for destructive cleanup." \
            --example="dockutils --stop" \
            --example="dockutils --clean --yes"
        return
    end

    __require_command docker or return

    if set -ql _flag_stop
        __stop
        return
    end

    if set -ql _flag_clean
        __clean (set -q _flag_yes; and echo yes)
        return
    end

    echo "Choose an action. Use --help for usage information."
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

function __clean --argument-names confirmed
    echo "Cleaning up all unused Docker data (containers, images, networks, build cache, volumes)..."

    if test "$confirmed" != yes
        __confirm "This will remove unused Docker containers, images, networks, build cache, and volumes."
        or begin
            echo "Cancelled."
            return 1
        end
    end

    docker system prune -af --volumes
    if test $status -ne 0
        echo "An error occurred during Docker system prune." >&2
        return 1
    end
    echo "Docker system clean-up complete."
end

complete -c dockutils -f
complete -c dockutils -s s -l stop -d "Stop all running Docker containers"
complete -c dockutils -s c -l clean -d "Clean unused Docker data"
complete -c dockutils -s y -l yes -d "Skip cleanup confirmation"
