#!/usr/bin/env fish

function help-view --description "Display formatted help text with usage, description, options, examples, aliases, dependencies, and exit codes"
    argparse \
        'u/usage=' \
        'd/description=' \
        'o/opt=+' \
        'e/example=+' \
        'a/alias=+' \
        'D/dependency=+' \
        'x/exit-code=+' \
        'no-help' \
        -- $argv or return

    if test -n "$_flag_usage"
        printf "Usage: %s\n" "$_flag_usage"
    end

    if test -n "$_flag_description"
        printf "%s\n" "$_flag_description"
    end

    if test -n "$_flag_alias"
        printf "\nAliases:\n"
        for alias_line in $_flag_alias
            printf "  %s\n" "$alias_line"
        end
    end

    if test -n "$_flag_dependency"
        printf "\nDependencies:\n"
        for dependency in $_flag_dependency
            printf "  %s\n" "$dependency"
        end
    end

    if test -n "$_flag_opt"; or not set -q _flag_no_help
        printf "\nOptions:\n"

        set -l every_option $_flag_opt

        if not set -q _flag_no_help
            set -a every_option "h/help Show this help message"
        end

        for opt in $every_option
            set -l parts (string split -m 1 ' ' -- $opt)
            set -l label $parts[1]
            set -l description ""
            if test (count $parts) -gt 1
                set description $parts[2]
            end
            printf "  %-24s %s\n" "$label" "$description"
        end
    end

    if test -n "$_flag_example"
        printf "\nExamples:\n"
        for example in $_flag_example
            printf "  %s\n" "$example"
        end
    end

    if test -n "$_flag_exit_code"
        printf "\nExit codes:\n"
        for exit_code in $_flag_exit_code
            printf "  %s\n" "$exit_code"
        end
    end
end
