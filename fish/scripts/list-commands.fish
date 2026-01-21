#!/usr/bin/env fish

set -l list_commands_desc "Lists all custom functions from scripts folder and shows their help output."
function list-commands --description $list_commands_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="list-commands" \
            --description=$list_commands_desc
        return
    end

    # Define colors (using fish color codes)
    set_color normal
    set -l color_normal (set_color normal)
    set_color cyan
    set -l color_header (set_color cyan)
    set_color green
    set -l color_fn_name (set_color green)
    set_color red
    set -l color_error (set_color red)
    set_color yellow
    set -l color_warn (set_color yellow)

    for f in ~/.dotfiles/fish/scripts/*.fish
        # Extract function names declared in the file
        set -l fn_names (grep -E '^function\s+[a-zA-Z0-9_-]+' $f | sed -E 's/^function\s+([a-zA-Z0-9_-]+).*/\1/')

        for fn_name in $fn_names
            if functions -q $fn_name
                echo ""
                echo "$color_fn_name$fn_name --help$color_normal"
                # Run function with --help and replace literal \n with actual newline; indent output nicely
                $fn_name --help | string replace '\\n' '\n' | sed 's/^/  /'
            else
                echo "$color_error [Error]$color_normal Function '$fn_name' declared in $f but not found!"
            end
        end
    end
end
