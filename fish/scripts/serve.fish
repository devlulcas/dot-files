#!/usr/bin/env fish

set -l serve_desc "Creates an HTTP server for local basic development using Python. Optional port argument (default: 2309)."
function serve --description $serve_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="serve [port]" \
            --description=$serve_desc
        return
    end

    set port 2309
    if set -q argv[1]
        set port $argv[1]
    end

    set dir (pwd)

    echo "Serving $dir on http://localhost:$port"
    python3 -m http.server $port --directory $dir &
    set pid $last_pid

    function __cleanup --on-event fish_exit
        kill $pid >/dev/null 2>&1
    end

    if type -q watchmedo
        echo "Watching for changes in HTML/CSS/JS..."
        watchmedo shell-command \
            --patterns="*.html;*.css;*.js" \
            --recursive \
            --command="echo '[Reload] File changed in $dir'" \
            --drop \
            --watch $dir
    else
        echo "Static server running without watch (watchdog not installed)"
        echo "Press Ctrl+C to stop"
        while true
            sleep 3600
        end
    end
end
