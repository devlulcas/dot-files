#!/usr/bin/env fish
sudo dnf install gtk4-devel gtk4-layer-shell-devel zig libadwaita-devel blueprint-compiler gettext
set -l GHOSTTY_COMPILE_DIR "$HOME/.local/bin"
mkdir -p "$GHOSTTY_COMPILE_DIR"
cd "$GHOSTTY_COMPILE_DIR"
git clone --depth 1 git@github.com:ghostty-org/ghostty.git Ghostty
cd Ghostty
zig build -p $HOME/.local -Doptimize=ReleaseFast
