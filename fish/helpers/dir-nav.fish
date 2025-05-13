function mkcd --description "Creates a directory and changes into it"
    if test (count $argv) -ne 1
        echo "Usage: mkcd <directory-name>" >&2
        return 1
    end
    mkdir -p $argv[1]
    and cd $argv[1]
end

function gocode
    if not set -q argv[1]
        echo "Usage: gocode <project-name>"
        return 1
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
