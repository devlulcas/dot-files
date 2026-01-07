#!/usr/bin/env fish

function hidefiles
    set -l usage "Usage: hidefiles <directory-name>"
    set -l desc "Creates a directory (including parent folders if needed) and changes into it."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    set dir $argv[1]

    if test -z "$dir"
        echo "usage: hidefiles <directory>"
        return 1
    end

    if not test -d "$dir"
        echo "error: '$dir' is not a directory"
        return 1
    end

    set files
    for f in "$dir"/*
        test -e "$f"; or continue
        set base (basename -- "$f")
        string match -q '.*' "$base"; and continue
        set files $files "$f"
    end

    if test (count $files) -eq 0
        echo "nothing to hide in $dir"
        return 0
    end

    echo "The following items will be hidden:"
    for f in $files
        set base (basename -- "$f")
        echo "  $base → .$base"
    end

    read -P "Proceed? [y/N] " confirm

    switch (string lower "$confirm")
        case y yes
            for f in $files
                set base (basename -- "$f")
                mv -- "$f" "$dir/.$base"
            end
        case '*'
            echo "aborted"
            return 1
    end
end