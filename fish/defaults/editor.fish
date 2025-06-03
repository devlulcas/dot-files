
# Editor preferences
set -gx PREFERRED_EDITOR "cursor"
set -gx FALLBACK_EDITOR "code"
set -gx TERMINAL_EDITOR "nvim"

set -gx CURSOR_CMD "$HOME/Applications/Cursor/cursor.AppImage"
set -gx CODE_CMD "code"
set -gx NVIM_CMD "nvim"

set -gx WORK_DIR "$HOME/Work"
set -gx CODING_DIR "$HOME/Coding"

function get_editor_cmd
    switch $PREFERRED_EDITOR
        case "cursor"
            if test -x "$CURSOR_CMD"
                echo "$CURSOR_CMD"
            else
                echo "$FALLBACK_EDITOR"
            end
        case "code"
            if command -v code >/dev/null
                echo "code"
            else
                echo "$FALLBACK_EDITOR"
            end
        case "nvim"
            echo "$NVIM_CMD"
        case "*"
            echo "$FALLBACK_EDITOR"
    end
end

function open_editor
    set -l editor_cmd (get_editor_cmd)
    
    if test (count $argv) -eq 0
        $editor_cmd . &>/dev/null &
        disown
    else
        $editor_cmd $argv &>/dev/null &
        disown
    end
end