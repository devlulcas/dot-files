#!/usr/bin/env fish

# Alias loader
source ~/.dotfiles/fish/alias.fish

# Load env
source ~/.dotfiles/fish/env.fish

# Lib loader (order matters)
source ~/.dotfiles/fish/lib/show-help.fish

# Now source all other scripts that depend on show_help
for f in ~/.dotfiles/fish/scripts/*.fish
    source $f
end

# Commands
source ~/.dotfiles/fish/commands.fish
