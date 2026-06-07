#!/usr/bin/env fish

set -l bonita_desc "Runs prettier on the current directory with the specified options"
function bonita --description $bonita_desc
    argparse 'h/help' 's/staged' 'a/all' -- $argv
    or return

    if set -ql _flag_help
        help-view \
            --usage="bonita" \
            --description=$bonita_desc
        return
    end

    if not command -v npx >/dev/null
        echo "Error: npx is not installed"
        return 1
    end

    function __check_prettier_config_exists
        set -l prettier_config_file_possible_paths \
            ".prettierrc" \
            ".prettierrc.json" \
            ".prettierrc.yml" \
            ".prettierrc.yaml" \
            ".prettierrc.json5" \
            ".prettierrc.js" \
            "prettier.config.js" \
            ".prettierrc.ts" \
            "prettier.config.ts" \
            ".prettierrc.mjs" \
            "prettier.config.mjs" \
            ".prettierrc.mts" \
            "prettier.config.mts" \
            ".prettierrc.cjs" \
            "prettier.config.cjs" \
            ".prettierrc.cts" \
            "prettier.config.cts" \
            ".prettierrc.toml"

        for config_path in $prettier_config_file_possible_paths
            if test -f $config_path
                return 0
            end
        end

        return 1
    end

    if not __check_prettier_config_exists
        echo "Error: No prettier config file found. Please create a .prettierrc file or a prettier.config.* file."
        return 1
    end

    if set -ql _flag_staged
        echo "Running prettier on staged files"
        npx prettier --write $(git diff --name-only --diff-filter=d --staged)
        if test $status -ne 0
            echo "Error: Failed to run prettier on staged files"
            return 1
        end
    end

    if set -ql _flag_all
        echo "Running prettier on all files"
        npx prettier --write .
        if test $status -ne 0
            echo "Error: Failed to run prettier on all files"
            return 1
        end
    end

    if set -ql _flag_
        echo "Running prettier with options: $argv"
        npx prettier $argv
        if test $status -ne 0
            echo "Error: Failed to run prettier with options: $argv"
            return 1
        end
    end
end
