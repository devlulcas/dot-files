#!/usr/bin/env fish

# Remove existing fish config file
set -l fish_config_file ~/.config/fish/config.fish
if test -e $fish_config_file; and not test -L $fish_config_file
    mv $fish_config_file $fish_config_file.backup
else if not test -L $fish_config_file
    # Link new config files
    ln -s ~/.dotfiles/fish/config.fish $fish_config_file 
end


# Link new git config file
if not test -e ~/.gitconfig
    ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
end

# Link new ghostty config file
set -l ghostty_config_file ~/.config/ghostty/config
if test -e $ghostty_config_file; and not test -L $ghostty_config_file
    mv $ghostty_config_file $ghostty_config_file.backup
else if not test -L $ghostty_config_file
    # Link new ghostty config file
    ln -s ~/.dotfiles/ghostty/config $ghostty_config_file
end
