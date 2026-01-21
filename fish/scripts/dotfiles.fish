#!/usr/bin/env fish

set -l dotfiles_desc "Opens the dotfiles project in the preferred editor"
function dotfiles --description $dotfiles_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="dotfiles" \
            --description=$dotfiles_desc
        return
    end

    code-editor ~/.dotfiles
end
