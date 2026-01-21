#!/usr/bin/env fish

set -l extract_desc "Extracts a compressed file based on its extension (e.g. .tar.gz, .zip, .7z)."
function extract --description $extract_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="extract <file>" \
            --description=$extract_desc
        return
    end

    switch $argv[1]
        case '*.tar.bz2'
            tar xvjf $argv[1]
        case '*.tar.gz'
            tar xvzf $argv[1]
        case '*.tar.xz'
            tar xvJf $argv[1]
        case '*.tar'
            tar xvf $argv[1]
        case '*.zip'
            unzip $argv[1]
        case '*.7z'
            7z x $argv[1]
        case '*'
            echo "Don't know how to extract $argv[1]"
    end
end
