#!/usr/bin/env fish

set -l rmbak_desc "Removes all backup files (*.bak) from the current directory."
function rmbak --description $rmbak_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="rmbak" \
            --description=$rmbak_desc
        return
    end

    echo "Removing backup files (*.bak)..."
    rm *.bak
end
