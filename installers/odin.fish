#!/usr/bin/env fish
sudo dnf install llvm-devel
mkdir -p "$ODIN_INSTALL_DIR"
cd "$ODIN_INSTALL_DIR"
git clone --depth 1 git@github.com:odin-lang/Odin.git
make release-native
