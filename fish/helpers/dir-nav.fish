function mkcd
    set -l usage "Usage: mkcd <directory-name>"
    set -l desc "Creates a directory (including parent folders if needed) and changes into it."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    mkdir -p $argv[1]
    and cd $argv[1]
end

function gocode
    set -l usage "Usage: gocode <project-name>"
    set -l desc "Searches for a project folder in ~/Work or ~/Coding and opens it in VS Code."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    # Try Work first
    set matches (find ~/Work -type d -mindepth 2 -maxdepth 2 -name "$argv[1]" 2>/dev/null)

    if test (count $matches) -eq 0
        # Try Coding
        set matches (find ~/Coding -maxdepth 1 -type d -name "$argv[1]" 2>/dev/null)
    end

    if test (count $matches) -eq 0
        echo "Project '$argv[1]' not found in ~/Work or ~/Coding"
        return 1
    end

    cd $matches[1]
    code .
end

# Completion for gocode
complete -c gocode -a "(ls -d ~/Coding/*/ ~/Work/*/*/ 2>/dev/null | xargs -n1 basename)" -f
