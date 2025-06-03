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