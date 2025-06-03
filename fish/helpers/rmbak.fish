function rmbak
    set -l usage "Usage: rmbak"
    set -l desc "Removes all backup files (*.bak) from the current directory."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    echo "Removing backup files (*.bak)..."
    rm *.bak
end
