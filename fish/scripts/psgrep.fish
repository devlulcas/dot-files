#!/usr/bin/env fish

function psgrep
    set -l usage "Usage: psgrep <process-name>"
    set -l desc "Searches for a process by name using a case-insensitive match."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    set search_term (string join '.*' $argv)
    ps aux | grep -i $search_term | grep -v grep
end
