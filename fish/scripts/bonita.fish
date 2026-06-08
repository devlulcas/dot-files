#!/usr/bin/env fish

set -l bonita_desc "Formats the current project with the best available formatter."
function bonita --description $bonita_desc
    argparse \
        'h/help' \
        's/staged' \
        'a/all' \
        'p/prettier' \
        'b/biome' \
        'g/go' \
        'r/rust' \
        'P/python' \
        'c/check' \
        'w/write' \
        'v/verbose' \
        -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="bonita [--staged] [--all] [--check|--write] [formatter flags]" \
            --description=$bonita_desc \
            --dependency="prettier or local npx prettier for Prettier projects" \
            --dependency="biome for Biome projects" \
            --dependency="go or gofmt for Go projects" \
            --dependency="cargo or rustfmt for Rust projects" \
            --dependency="ruff or black for Python projects" \
            --opt="s/staged Format only staged files when supported." \
            --opt="a/all Run every detected formatter." \
            --opt="p/prettier Force Prettier." \
            --opt="b/biome Force Biome." \
            --opt="g/go Force Go formatting." \
            --opt="r/rust Force Rust formatting." \
            --opt="P/python Force Python formatting." \
            --opt="c/check Check formatting without writing changes." \
            --opt="w/write Write formatting changes. This is the default." \
            --opt="v/verbose Show skipped formatters and selection reasons." \
            --example="bonita" \
            --example="bonita --staged" \
            --example="bonita --biome --check" \
            --example="bonita --go --rust"
        return
    end

    set -l mode write
    if set -ql _flag_check
        set mode check
    end

    set -g __bonita_verbose 0
    if set -ql _flag_verbose
        set __bonita_verbose 1
    end

    set -l scope project
    if set -ql _flag_staged
        set scope staged
        __require_git_repo or return
    end

    set -l selected
    if set -ql _flag_prettier
        set -a selected prettier
    end
    if set -ql _flag_biome
        set -a selected biome
    end
    if set -ql _flag_go
        set -a selected go
    end
    if set -ql _flag_rust
        set -a selected rust
    end
    if set -ql _flag_python
        set -a selected python
    end

    if test (count $selected) -eq 0
        set selected (__bonita_detect_formatters)
    end

    if set -ql _flag_all
        set selected (__bonita_detect_formatters --all)
    end

    if test (count $selected) -eq 0
        echo "No formatter detected for this project."
        set --erase __bonita_verbose
        return 1
    end

    set -l failed 0
    for formatter in $selected
        switch $formatter
            case prettier
                __bonita_run_prettier $scope $mode
            case biome
                __bonita_run_biome $scope $mode
            case go
                __bonita_run_go $scope $mode
            case rust
                __bonita_run_rust $scope $mode
            case python
                __bonita_run_python $scope $mode
        end

        if test $status -ne 0
            set failed 1
        end
    end

    set --erase __bonita_verbose
    return $failed
end

function __bonita_detect_formatters --description "Detect project formatters"
    set -l include_all 0
    if test "$argv[1]" = --all
        set include_all 1
    end

    set -l formatters
    set -l has_prettier_config (__bonita_has_any_file \
        .prettierrc .prettierrc.json .prettierrc.yml .prettierrc.yaml .prettierrc.json5 \
        .prettierrc.js prettier.config.js .prettierrc.ts prettier.config.ts \
        .prettierrc.mjs prettier.config.mjs .prettierrc.cjs prettier.config.cjs .prettierrc.toml)
    set -l has_biome_config (__bonita_has_any_file biome.json biome.jsonc)

    if test -n "$has_biome_config"
        set -a formatters biome
    end

    if test -n "$has_prettier_config"
        set -a formatters prettier
    else if test $include_all -eq 1; and __bonita_has_extension js jsx ts tsx css scss html json md yml yaml
        set -a formatters prettier
    end

    if __bonita_has_any_file go.mod >/dev/null; or __bonita_has_extension go
        set -a formatters go
    end

    if __bonita_has_any_file Cargo.toml >/dev/null; or __bonita_has_extension rs
        set -a formatters rust
    end

    if __bonita_has_extension py
        set -a formatters python
    end

    printf "%s\n" $formatters | string match -v ''
end

function __bonita_has_any_file
    for path in $argv
        if test -e "$path"
            echo "$path"
            return 0
        end
    end

    return 1
end

function __bonita_has_extension
    for extension in $argv
        set -l found (find . -path ./.git -prune -o -type f -name "*.$extension" -print -quit 2>/dev/null)
        if test -n "$found"
            return 0
        end
    end

    return 1
end

function __bonita_staged_files
    git diff --name-only --diff-filter=d --staged
end

function __bonita_files_with_extensions
    set -l separator_index (contains -i -- -- $argv)
    if test -z "$separator_index"
        return 1
    end

    set -l extension_end (math $separator_index - 1)
    set -l file_start (math $separator_index + 1)
    if test $extension_end -lt 1; or test $file_start -gt (count $argv)
        return 0
    end

    set -l extensions $argv[1..$extension_end]
    set -l files $argv[$file_start..-1]
    set -l matched

    for file in $files
        for extension in $extensions
            if string match -q "*.$extension" -- "$file"
                set -a matched "$file"
                break
            end
        end
    end

    printf "%s\n" $matched
end

function __bonita_print_skip --argument-names formatter reason
    if test "$__bonita_verbose" = 1
        echo "Skipping $formatter: $reason"
    end
end

function __bonita_run_prettier --argument-names scope mode
    set -l prettier_cmd
    if command -q prettier
        set prettier_cmd prettier
    else if command -q npx
        set prettier_cmd npx --no-install prettier
    else
        __bonita_print_skip prettier "prettier and npx are not available"
        return 0
    end

    set -l action --write
    if test "$mode" = check
        set action --check
    end

    if test "$scope" = staged
        set -l files (__bonita_files_with_extensions js jsx ts tsx css scss html json md yml yaml -- (__bonita_staged_files))
        if test (count $files) -eq 0
            __bonita_print_skip prettier "no staged frontend files"
            return 0
        end

        echo "Running Prettier on staged files..."
        $prettier_cmd $action $files
        return $status
    end

    echo "Running Prettier..."
    $prettier_cmd $action .
end

function __bonita_run_biome --argument-names scope mode
    if not command -q biome
        __bonita_print_skip biome "biome is not available"
        return 0
    end

    set -l action --write
    if test "$mode" = check
        set action ""
    end

    if test "$scope" = staged
        set -l files (__bonita_files_with_extensions js jsx ts tsx css json jsonc -- (__bonita_staged_files))
        if test (count $files) -eq 0
            __bonita_print_skip biome "no staged Biome-supported files"
            return 0
        end

        echo "Running Biome on staged files..."
        biome format $action $files
        return $status
    end

    echo "Running Biome..."
    biome format $action .
end

function __bonita_run_go --argument-names scope mode
    __require_one_command "Go formatting" gofmt go or return

    if test "$scope" = staged
        set -l files (__bonita_files_with_extensions go -- (__bonita_staged_files))
        if test (count $files) -eq 0
            __bonita_print_skip go "no staged Go files"
            return 0
        end

        if test "$mode" = check
            set -l unformatted (gofmt -l $files)
            if test -n "$unformatted"
                printf "%s\n" $unformatted
                return 1
            end
            return 0
        end

        echo "Running gofmt on staged files..."
        gofmt -w $files
        return $status
    end

    if test "$mode" = check
        set -l files (find . -path ./.git -prune -o -type f -name "*.go" -print)
        set -l unformatted (gofmt -l $files)
        if test -n "$unformatted"
            printf "%s\n" $unformatted
            return 1
        end
        return 0
    end

    if test -e go.mod; and command -q go
        echo "Running go fmt ./..."
        go fmt ./...
    else
        set -l files (find . -path ./.git -prune -o -type f -name "*.go" -print)
        echo "Running gofmt..."
        gofmt -w $files
    end
end

function __bonita_run_rust --argument-names scope mode
    if test "$scope" = staged
        __require_command rustfmt or return
        set -l files (__bonita_files_with_extensions rs -- (__bonita_staged_files))
        if test (count $files) -eq 0
            __bonita_print_skip rust "no staged Rust files"
            return 0
        end

        if test "$mode" = check
            echo "Checking staged Rust files with rustfmt..."
            rustfmt --check $files
        else
            echo "Running rustfmt on staged files..."
            rustfmt $files
        end
        return $status
    end

    if test -e Cargo.toml; and command -q cargo
        if test "$mode" = check
            echo "Checking Rust formatting with cargo fmt..."
            cargo fmt -- --check
        else
            echo "Running cargo fmt..."
            cargo fmt
        end
        return $status
    end

    __require_command rustfmt or return
    set -l files (find . -path ./.git -prune -o -type f -name "*.rs" -print)
    if test "$mode" = check
        rustfmt --check $files
    else
        rustfmt $files
    end
end

function __bonita_run_python --argument-names scope mode
    set -l formatter (__first_available_command ruff black)
    if test -z "$formatter"
        __bonita_print_skip python "ruff or black is not available"
        return 0
    end

    set -l files
    if test "$scope" = staged
        set files (__bonita_files_with_extensions py -- (__bonita_staged_files))
        if test (count $files) -eq 0
            __bonita_print_skip python "no staged Python files"
            return 0
        end
    else
        set files (find . -path ./.git -prune -o -type f -name "*.py" -print)
    end

    if test (count $files) -eq 0
        __bonita_print_skip python "no Python files"
        return 0
    end

    switch "$formatter"
        case ruff
            if test "$mode" = check
                echo "Checking Python formatting with ruff..."
                ruff format --check $files
            else
                echo "Running ruff format..."
                ruff format $files
            end
        case black
            if test "$mode" = check
                echo "Checking Python formatting with black..."
                black --check $files
            else
                echo "Running black..."
                black $files
            end
    end
end

complete -c bonita -f
complete -c bonita -s s -l staged -d "Format only staged files"
complete -c bonita -s a -l all -d "Run every detected formatter"
complete -c bonita -s p -l prettier -d "Force Prettier"
complete -c bonita -s b -l biome -d "Force Biome"
complete -c bonita -s g -l go -d "Force Go formatting"
complete -c bonita -s r -l rust -d "Force Rust formatting"
complete -c bonita -s P -l python -d "Force Python formatting"
complete -c bonita -s c -l check -d "Check formatting"
complete -c bonita -s w -l write -d "Write formatting changes"
complete -c bonita -s v -l verbose -d "Show formatter selection details"
