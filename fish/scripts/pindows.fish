#!/usr/bin/env fish

set -l pindows_desc "Opens WinBoat browser window."
function pindows --description $pindows_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="pindows" \
            --description=$pindows_desc \
            --dependency="docker" \
            --dependency="xdg-open or open" \
            --example="pindows"
        return
    end

    __require_command docker or return
    __require_one_command "opening URLs" xdg-open open or return

    set -l browser_cmd (__first_available_command xdg-open open)
    set -l port_line (docker port WinBoat 8006 2>/dev/null)

    if test -z "$port_line"
        __error "Could not find port 8006 for the WinBoat container"
        return 1
    end

    set -l url "http://$port_line"
    $browser_cmd "$url" >/dev/null 2>/dev/null &
    disown
end
