function bak
    if test (count $argv) -ne 1
        echo "Usage: bak <file>"
        return 1
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
    echo "Removing backup files (*.bak)..."
    rm *.bak
end