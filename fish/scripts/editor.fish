#!/usr/bin/env fish

set -l code_editor_desc "Opens the preferred editor with the current directory or the specified directory."
function code-editor --description $code_editor_desc
    argparse 'h/help' 'w/wait' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="code-editor [--wait] [path...]" \
            --description=$code_editor_desc \
            --opt="w/wait Wait for the editor process to close when supported." \
            --example="code-editor" \
            --example="code-editor --wait README.md"
        return
    end

    set -l editor_cmd (__get_editor_cmd)
    or return 1

    set -l editor_args $argv
    if test (count $editor_args) -eq 0
        set editor_args .
    end

    if set -ql _flag_wait
        switch $editor_cmd
            case code cursor
                $editor_cmd --wait $editor_args
            case '*'
                $editor_cmd $editor_args
        end
    else
        $editor_cmd $editor_args &>/dev/null &
        disown
    end
end

function __get_editor_cmd --description "Resolve the configured editor command"
    set -l candidates $PREFERRED_EDITOR $FALLBACK_EDITOR $TERMINAL_EDITOR

    for editor in $candidates
        if test -n "$editor"; and command -q "$editor"
            echo "$editor"
            return 0
        end
    end

    __error "No configured editor is available. Checked: "(string join ", " $candidates)
    return 1
end
