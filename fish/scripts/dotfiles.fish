#!/usr/bin/env fish

set -l dotfiles_desc "Manage this dotfiles project"
function dotfiles --description $dotfiles_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="dotfiles [edit|doctor|relink|sync|check]" \
            --description=$dotfiles_desc \
            --example="dotfiles edit" \
            --example="dotfiles doctor" \
            --example="dotfiles check" \
            --example="dotfiles relink"
        return
    end

    set -l command $argv[1]
    if test -z "$command"
        set command edit
    end

    switch "$command"
        case edit
            code-editor ~/.dotfiles
        case doctor
            fish ~/.dotfiles/setup.fish --doctor
        case relink
            fish ~/.dotfiles/setup.fish
        case sync
            __require_command git or return
            git -C ~/.dotfiles pull --ff-only
        case check
            __dotfiles_check
        case '*'
            __error "Unknown dotfiles command: $command"
            dotfiles --help
            return 1
    end
end

function __dotfiles_check --description "Run local dotfiles quality checks"
    set -l repo ~/.dotfiles
    set -l failed 0

    echo "Checking fish syntax..."
    fish -n \
        "$repo"/fish/config.fish \
        "$repo"/fish/env.fish \
        "$repo"/fish/preferences.fish \
        "$repo"/fish/alias.fish \
        "$repo"/fish/lib/*.fish \
        "$repo"/fish/scripts/*.fish \
        "$repo"/init.fish \
        "$repo"/setup.fish
    or set failed 1

    echo "Checking JSON files..."
    if command -q python3
        for file in "$repo"/*.json
            python3 -m json.tool "$file" >/dev/null
            or begin
                __error "Invalid JSON: $file"
                set failed 1
            end
        end
    else if command -q jq
        for file in "$repo"/*.json
            jq empty "$file" >/dev/null
            or begin
                __error "Invalid JSON: $file"
                set failed 1
            end
        end
    else
        echo "Skipping JSON validation: install python3 or jq."
    end

    if string match -q "*init.sh*" (string collect <"$repo/README.md")
        __error "README still references init.sh"
        set failed 1
    end

    return $failed
end

complete -c dotfiles -f -a "edit doctor relink sync check"
