#!/usr/bin/env fish

function help-view --description "Display formatted help text with usage, description, and options"
    argparse 'u/usage=' 'd/description=' 'o/opt=+' 'no-help' -- $argv or return
    
    # Print usage if provided
    if test -n "$_flag_usage"
        printf "Usage: %s\n" "$_flag_usage"
    end
    
    # Print description if provided
    if test -n "$_flag_description"
        printf "%s\n" "$_flag_description"
    end
    
    # Print options if provided or if help should be shown
    if test -n "$_flag_opt"; or not set -q _flag_no_help
        printf "\nOptions:\n"
        
        set -l every_option $_flag_opt

        # Add help option
        if not set -q _flag_no_help
          set -a every_option "h/help Show this help message"
        end

        # Print custom options first
        for opt in $every_option
            # Split on first space to get flag and description
            set -l parts (string split -m 1 ' ' -- $opt)
            printf "  %-20s %s\n" $parts[1] $parts[2]
        end
    end
end
