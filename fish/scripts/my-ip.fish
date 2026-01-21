#!/usr/bin/env fish

set -l my_ip_desc "Shows the local and external IP addresses."
function my-ip --description $my_ip_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="my-ip" \
            --description=$my_ip_desc
        return
    end

    echo "Local IP:"
    ip -c a | grep -w inet | grep global | awk '{print $2}' | cut -d / -f 1
    echo ""
    echo "External IP:"
    curl ifconfig.me
    echo ""
end
