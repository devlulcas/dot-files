#!/usr/bin/env fish

function open_editor
    set -l usage "Usage: open_editor [directory]"
    set -l desc "Opens the preferred editor with the current directory or the specified directory."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    function get_editor_cmd
        switch $PREFERRED_EDITOR
            case cursor
                if test -x "$CURSOR_CMD"
                    echo "$CURSOR_CMD"
                else
                    echo "$FALLBACK_EDITOR"
                end
            case code
                if command -v code >/dev/null
                    echo code
                else
                    echo "$FALLBACK_EDITOR"
                end
            case nvim
                echo "$NVIM_CMD"
            case "*"
                echo "$FALLBACK_EDITOR"
        end
    end

    set -l editor_cmd (get_editor_cmd)

    if test (count $argv) -eq 0
        $editor_cmd . &>/dev/null &
        disown
    else
        $editor_cmd $argv &>/dev/null &
        disown
    end
end
