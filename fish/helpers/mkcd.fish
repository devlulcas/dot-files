function mkcd
    set -l usage "Usage: mkcd <directory-name>"
    set -l desc "Creates a directory (including parent folders if needed) and changes into it."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    mkdir -p $argv[1]
    and cd $argv[1]
end