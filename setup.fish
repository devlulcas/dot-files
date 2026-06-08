#!/usr/bin/env fish

set -l repo_dir (realpath (status dirname))
set -l timestamp (date +%Y%m%d-%H%M%S)

function __setup_info --argument-names message
    echo "$message"
end

function __setup_warn --argument-names message
    echo "Warning: $message" >&2
end

function __setup_link --argument-names source target
    set -l target_dir (dirname "$target")
    mkdir -p "$target_dir"

    if test -L "$target"
        set -l current_target (readlink "$target")
        if test "$current_target" = "$source"
            __setup_info "Already linked: $target -> $source"
            return 0
        end

        set -l backup "$target.backup.$timestamp"
        mv "$target" "$backup"
        __setup_warn "Moved existing symlink to $backup"
    else if test -e "$target"
        set -l backup "$target.backup.$timestamp"
        mv "$target" "$backup"
        __setup_warn "Moved existing file to $backup"
    end

    ln -s "$source" "$target"
    __setup_info "Linked: $target -> $source"
end

function __setup_check_command --argument-names command_name required
    if command -q "$command_name"
        echo "ok  $command_name"
        return 0
    end

    if test "$required" = required
        echo "miss required  $command_name"
        return 1
    end

    echo "miss optional  $command_name"
    return 0
end

argparse 'h/help' 'd/doctor' 'n/dry-run' -- $argv or exit 1

if set -ql _flag_help
    echo "Usage: fish ./setup.fish [--doctor] [--dry-run]"
    echo "Re-establish dotfile symlinks and check a fresh development environment."
    echo
    echo "Options:"
    echo "  h/help        Show this help message"
    echo "  d/doctor      Only run environment checks"
    echo "  n/dry-run     Print planned links without changing files"
    exit 0
end

set -l required_commands fish git
set -l optional_commands curl code cursor nvim docker flatpak dnf tesseract wl-copy notify-send lsof npx biome go cargo gofmt rustfmt xdg-open

set -l failed 0
echo "Checking required tools..."
for command_name in $required_commands
    __setup_check_command "$command_name" required
    or set failed 1
end

echo
echo "Checking optional tools..."
for command_name in $optional_commands
    __setup_check_command "$command_name" optional
end

if set -ql _flag_doctor
    exit $failed
end

if set -ql _flag_dry_run
    echo
    echo "Would link:"
    echo "  $repo_dir/fish/config.fish -> $HOME/.config/fish/config.fish"
    echo "  $repo_dir/git/.gitconfig -> $HOME/.gitconfig"
    echo "  $repo_dir/ghostty/config -> $HOME/.config/ghostty/config"
    exit $failed
end

echo
echo "Linking dotfiles..."
__setup_link "$repo_dir/fish/config.fish" "$HOME/.config/fish/config.fish"
__setup_link "$repo_dir/git/.gitconfig" "$HOME/.gitconfig"
__setup_link "$repo_dir/ghostty/config" "$HOME/.config/ghostty/config"

echo
echo "Setup complete. Run 'dotfiles doctor' after opening a new shell for a fuller check."
exit $failed
