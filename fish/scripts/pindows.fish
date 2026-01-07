#!/usr/bin/env fish

function pindows
    set -l usage "Usage: pindows"
    set -l desc "Opens WinBoat browser window"

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    open (docker port WinBoat | grep "8006" | awk '{print "http://" $3}')
end

