function myip
    set -l usage "Usage: myip"
    set -l desc "Shows the local and external IP addresses."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    echo "Local IP:"
    ip -c a | grep -w inet | grep global | awk '{print $2}' | cut -d '/' -f 1
    echo ""
    echo "External IP:"
    curl ifconfig.me
    echo ""
end

function serve
    set -l usage "Usage: serve [port]"
    set -l desc "Creates an HTTP server for local basic development using Python. Optional port argument (default: 2309)."

    if show_help "$usage" "$desc" $argv[1]
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

    function cleanup --on-event fish_exit
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
