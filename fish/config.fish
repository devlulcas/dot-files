# Load env
source ~/.dotfiles/fish/env.fish

# Lib loader (order matters)
source ~/.dotfiles/fish/lib/show-help.fish

# Now source all other helpers that depend on show_help
for f in ~/.dotfiles/fish/defaults/*.fish
    source $f
end

# Now source all other helpers that depend on show_help
for f in ~/.dotfiles/fish/helpers/*.fish
    source $f
end

# Require helpers functions to be loaded
source ~/.dotfiles/fish/lib/me.fish

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
