#!/usr/bin/env fish

# Directories
set -gx WORK_DIR "$HOME/Work"
set -gx CODING_DIR "$HOME/Coding"
set -gx APPS_DIR "$HOME/Applications"

# Git
set -gx GIT_EDITOR nvim
set -gx GIT_PAGER nvim

# Editor
set -gx PREFERRED_EDITOR cursor
set -gx FALLBACK_EDITOR code
set -gx TERMINAL_EDITOR nvim

# Rust
if test -e "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end

# Go
set -gx GOPATH "$APPS_DIR/Go"

# Ghostty
fish_add_path "$HOME/.local/bin"

# PNPM
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
