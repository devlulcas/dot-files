function gocode
    set -l usage "Usage: gocode <project-name>"
    set -l desc "Searches for a project folder in ~/Work or ~/Coding and opens it in the default editor."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    # Try Work first
    set matches (find $WORK_DIR -type d -mindepth 2 -maxdepth 2 -name "$argv[1]" 2>/dev/null)

    if test (count $matches) -eq 0
        # Try Coding directory
        set matches (find $CODING_DIR -maxdepth 1 -type d -name "$argv[1]" 2>/dev/null)
    end

    if test (count $matches) -eq 0
        echo "Project '$argv[1]' not found in $WORK_DIR or $CODING_DIR"
        return 1
    end

    open_editor $matches[1]
end

# Completion for gocode
complete -c gocode -f -a "(__gocode_complete)"

function __gocode_complete
    # Use global variables if available, fallback to hardcoded paths
    set -l coding_dir (test -n "$CODING_DIR"; and echo "$CODING_DIR"; or echo "$HOME/Coding")
    set -l work_dir (test -n "$WORK_DIR"; and echo "$WORK_DIR"; or echo "$HOME/Work")
    
    ls -d $coding_dir/*/ $work_dir/*/*/ 2>/dev/null | xargs -n1 basename
end