#!/usr/bin/env fish

set -l code_editor_desc "Opens the preferred editor with the current directory or the specified directory."
function code-editor --description $code_editor_desc
    argparse 'h/help' -- $argv

    if set -ql _flag_help
        help-view \
            --usage="code-editor [directory]" \
            --description=$code_editor_desc
        return
    end
    
    function get-editor-cmd
        switch $PREFERRED_EDITOR
            case cursor
                if  command -v cursor >/dev/null
                    echo cursor
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
                if command -v nvim >/dev/null
                    echo nvim
                else
                    echo "$FALLBACK_EDITOR"
                end
            case "*"
                echo "$FALLBACK_EDITOR"
        end
    end

    set -l editor_cmd (get-editor-cmd)

    if test (count $argv) -eq 0
        $editor_cmd . &>/dev/null &
        disown
    else
        $editor_cmd $argv &>/dev/null &
        disown
    end
end
