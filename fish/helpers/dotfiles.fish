function dotfiles
    set -l usage "Usage: dotfiles"
    set -l desc "Opens the dotfiles project in VS Code."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    code ~/.dotfiles
end
