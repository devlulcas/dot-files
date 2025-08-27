mkdir -p "$APPS_DIR/Odin"
cd "$APPS_DIR/Odin"

git clone --depth 1 git@github.com:odin-lang/Odin.git

sudo dnf install llvm-devel

make release-native
