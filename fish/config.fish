#!/usr/bin/env fish

# Alias loader
source ~/.dotfiles/fish/alias.fish

# Load env
source ~/.dotfiles/fish/env.fish

# Lib loader (order matters)
source ~/.dotfiles/fish/lib/help-view.fish

# Now source all other scripts that depend on show-help
for f in ~/.dotfiles/fish/scripts/*.fish
    source $f
end

# Commands
source ~/.dotfiles/fish/scripts/list-commands.fish

# Greetings
set -U fish_greeting
