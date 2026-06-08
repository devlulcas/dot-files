#!/usr/bin/env fish

function __error --argument-names message --description "Print a consistent error message"
    echo "Error: $message" >&2
end

function __info --argument-names message --description "Print a consistent info message"
    echo "$message"
end

function __require_arg --argument-names name value --description "Require a non-empty argument value"
    if test -z "$value"
        __error "Missing required argument: $name"
        return 1
    end
end

function __require_command --argument-names command_name --description "Require a command to exist"
    if not command -q "$command_name"
        __error "Required command '$command_name' is not installed or not in PATH"
        return 1
    end
end

function __require_one_command --description "Require at least one command from a list"
    set -l label $argv[1]
    set -l commands $argv[2..-1]

    for command_name in $commands
        if command -q "$command_name"
            return 0
        end
    end

    __error "Missing required command for $label. Install one of: "(string join ", " $commands)
    return 1
end

function __require_git_repo --description "Require the current directory to be inside a git repository"
    if not command -q git
        __error "Required command 'git' is not installed or not in PATH"
        return 1
    end

    git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
    if test $status -ne 0
        __error "This command must be run inside a git repository"
        return 1
    end
end

function __require_numeric_port --argument-names port --description "Require a valid TCP port number"
    if not string match -qr '^[0-9]+$' -- "$port"
        __error "Port must be a number between 1 and 65535"
        return 1
    end

    if test "$port" -lt 1; or test "$port" -gt 65535
        __error "Port must be between 1 and 65535"
        return 1
    end
end

function __confirm --argument-names prompt --description "Ask for y/N confirmation"
    read --prompt-str "$prompt [y/N] " --local answer
    switch (string lower -- "$answer")
        case y yes
            return 0
        case '*'
            return 1
    end
end

function __first_available_command --description "Print the first command that exists"
    for command_name in $argv
        if command -q "$command_name"
            echo "$command_name"
            return 0
        end
    end

    return 1
end
