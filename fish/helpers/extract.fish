function extract
    set -l usage "Usage: extract <file>"
    set -l desc "Extracts a compressed file based on its extension (e.g. .tar.gz, .zip, .7z)."

    if show_help "$usage" "$desc" $argv[1]
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
