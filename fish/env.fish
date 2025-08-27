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

set -gx CURSOR_CMD "$APPS_DIR/Cursor/cursor.AppImage"
set -gx CODE_CMD code
set -gx NVIM_CMD nvim

# Rust
source "$HOME/.cargo/env.fish"

# Go
set -gx GOPATH "$APPS_DIR/go"

# Odin
set -g ODIN_INSTALL_DIR "$APPS_DIR/Odin"
fish_add_path "$ODIN_INSTALL_DIR"

# PNPM
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
