function bak
    set -l usage "Usage: bak <file>"
    set -l desc "Creates a copy of the file for backup with datetime information."
    if show_help "$usage" "$desc" $argv[1]
        return
    end

    set original_file $argv[1]
    if not test -f $original_file
        echo "Error: File '$original_file' not found."
        return 1
    end
    set backup_file "$original_file.(date +%Y%m%d_%H%M%S).bak"
    cp $original_file $backup_file
    echo "Backed up '$original_file' to '$backup_file'"
end

function rmbak
    set -l usage "Usage: rmbak"
    set -l desc "Removes all backup files (*.bak) from the current directory."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    echo "Removing backup files (*.bak)..."
    rm *.bak
end