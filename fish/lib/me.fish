function me
    set -l usage "Usage: me"
    set -l desc "Lists all custom functions from helpers folder and shows their help output."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    # Define colors (using fish color codes)
    set_color normal; set -l color_normal (set_color normal)
    set_color cyan;   set -l color_header (set_color cyan)
    set_color green;  set -l color_funcname (set_color green)
    set_color red;    set -l color_error (set_color red)
    set_color yellow; set -l color_warn (set_color yellow)

    for f in ~/.dotfiles/fish/helpers/*.fish
        # Extract function names declared in the file
        set funcs (grep -E '^function\s+[a-zA-Z0-9_-]+' $f | sed -E 's/^function\s+([a-zA-Z0-9_-]+).*/\1/')

        for func in $funcs
            if functions -q $func
                echo ""
                echo "$color_funcname$func --help$color_normal"
                # Run function with --help and replace literal \n with actual newline; indent output nicely
                $func --help | string replace '\\n' '\n' | sed 's/^/  /'
            else
                echo "$color_error [Error]$color_normal Function '$func' declared in $f but not found!"
            end
        end
    end
end
