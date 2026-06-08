#!/usr/bin/env fish

set -l gocode_desc "Searches for a project folder in ~/Work or ~/Coding and opens it in the preferred editor."
function gocode --description $gocode_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="gocode <project-name>" \
            --description=$gocode_desc \
            --example="gocode api" \
            --example="gocode dotfiles"
        return
    end

    __require_arg "project-name" "$argv[1]" or return

    # Try Work first
    set -l matches
    if test -d "$WORK_DIR"
        set matches (find "$WORK_DIR" -type d -mindepth 2 -maxdepth 2 -name "$argv[1]" 2>/dev/null)
    end

    if test (count $matches) -eq 0
        # Try Coding directory
        if test -d "$CODING_DIR"
            set matches (find "$CODING_DIR" -maxdepth 1 -type d -name "$argv[1]" 2>/dev/null)
        end
    end

    if test (count $matches) -eq 0
        echo "Project '$argv[1]' not found in $WORK_DIR or $CODING_DIR"
        return 1
    end

    if test (count $matches) -gt 1
        echo "Multiple projects found. Opening the first match:"
        for match in $matches
            echo "  $match"
        end
    end

    code-editor $matches[1]
end

function __gocode_relative_time --argument-names mtime
    set -l now (date +%s)
    set -l seconds (math $now - $mtime)

    if test $seconds -lt 60
        echo "just now"
    else if test $seconds -lt 3600
        echo (math --scale=0 "floor($seconds / 60)")"m ago"
    else if test $seconds -lt 86400
        echo (math --scale=0 "floor($seconds / 3600)")"h ago"
    else if test $seconds -lt 604800
        echo (math --scale=0 "floor($seconds / 86400)")"d ago"
    else if test $seconds -lt 31536000
        date --date="@$mtime" "+%b %d"
    else
        date --date="@$mtime" "+%Y-%m-%d"
    end
end

function __gocode_complete
    set -l projects
    set -l sep (printf "\x1f")

    if test -d "$CODING_DIR"
        for project in (find "$CODING_DIR" -mindepth 1 -maxdepth 1 -type d ! -name ".*" 2>/dev/null)
            set -l mtime (stat --format=%Y "$project" 2>/dev/null)
            if test -n "$mtime"
                set -a projects "$mtime$sep"(basename "$project")"$sep"
            end
        end
    end

    if test -d "$WORK_DIR"
        for project in (find "$WORK_DIR" -mindepth 2 -maxdepth 2 -type d ! -path "*/.*/*" ! -name ".*" 2>/dev/null)
            set -l mtime (stat --format=%Y "$project" 2>/dev/null)
            if test -n "$mtime"
                set -a projects "$mtime$sep"(basename "$project")"$sep"(basename (dirname "$project"))
            end
        end
    end

    for project in (printf "%s\n" $projects | sort --numeric-sort --reverse)
        set -l parts (string split $sep "$project")
        set -l name $parts[2]
        set -l parent ""
        if test (count $parts) -gt 2
            set parent $parts[3]
        end
        set -l time_str (__gocode_relative_time $parts[1])

        if test -n "$parent"
            printf "%s\t%s · %s\n" "$name" "$parent" "$time_str"
        else
            printf "%s\t%s\n" "$name" "$time_str"
        end
    end
end

# Completion for gocode
complete -c gocode -f --keep-order -a "(__gocode_complete)"
