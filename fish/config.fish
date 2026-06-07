#!/usr/bin/env fish

# Preferences
source ~/.dotfiles/fish/preferences.fish

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

# Greetings
set -U fish_greeting
