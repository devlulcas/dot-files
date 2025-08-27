# Load env
source ~/.dotfiles/fish/env.fish

# Lib loader (order matters)
source ~/.dotfiles/fish/lib/show-help.fish

# Now source all other helpers that depend on show_help
for f in ~/.dotfiles/fish/helpers/*.fish
    source $f
end

# Commands
source ~/.dotfiles/fish/commands.fish