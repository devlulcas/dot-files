#!/usr/bin/env fish

set -l mkcd_desc "Creates a directory (including parent folders if needed) and changes into it."
function mkcd --description $mkcd_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="mkcd <directory-name>" \
            --description=$mkcd_desc
        return
    end

    mkdir -p $argv[1]
    and cd $argv[1]
end
