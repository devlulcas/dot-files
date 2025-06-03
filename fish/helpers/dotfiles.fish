function dotfiles
    set -l usage "Usage: dotfiles"
    set -l desc "Opens the dotfiles project in teh default editor."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    open_editor ~/.dotfiles
end
