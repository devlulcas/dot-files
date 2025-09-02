#!/usr/bin/env fish

function show_help
    set -l usage "Usage: show_help <usage-string> <description> [arg]"
    set -l desc "Displays help information if the third argument is --help or -h."

    if test "$argv[1]" = --help -o "$argv[1]" = -h
        printf "%s\n%s\n" "$usage" "$desc"
        return 0
    end

    if test "$argv[3]" = --help -o "$argv[3]" = -h
        printf "%s\n%s\n" "$argv[1]" "$argv[2]"
        return 0
    end

    return 1
end
