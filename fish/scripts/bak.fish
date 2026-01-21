#!/usr/bin/env fish

set -l bak_desc "Creates a copy of the file for backup with datetime information."
function bak --description $bak_desc
    argparse 'h/help' 'r/rm' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="bak <file>" \
            --description=$bak_desc
        return
    end

    if set -ql _flag_rm
        __rmbak
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

function __rmbak
    echo "Removing backup files (*.bak)..."
    rm *.bak
end
