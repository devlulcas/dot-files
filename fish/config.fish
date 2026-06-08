#!/usr/bin/env fish

# Preferences
source ~/.dotfiles/fish/preferences.fish

# Alias loader
source ~/.dotfiles/fish/alias.fish

# Load env
source ~/.dotfiles/fish/env.fish

# Lib loader (order matters)
for f in ~/.dotfiles/fish/lib/*.fish
    source $f
end

# Now source all other scripts that depend on shared helpers
for f in ~/.dotfiles/fish/scripts/*.fish
    source $f
end

# Local machine overrides
if test -e ~/.dotfiles.local.fish
    source ~/.dotfiles.local.fish
end

# Greetings
set -U fish_greeting
