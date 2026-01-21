#!/usr/bin/env fish

set -l pindows_desc "Opens WinBoat browser window."
function pindows --description $pindows_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="pindows" \
            --description=$pindows_desc
        return
    end

    open (docker port WinBoat | grep "8006" | awk '{print "http://" $3}')
end

