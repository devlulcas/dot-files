#!/usr/bin/env fish

set -l hidefiles_desc "Hides files in a directory by renaming them to include a dot (.) prefix. Hidden files are skipped by default."
function hidefiles --description $hidefiles_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="hidefiles <directory>" \
            --description=$hidefiles_desc
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
