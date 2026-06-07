#!/usr/bin/env fish

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

# ASDF
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

# OPEN CODE
fish_add_path "$HOME/.opencode/bin"

# BIOME
fish_add_path "$APPS_DIR/RawBin/biome/bin"
