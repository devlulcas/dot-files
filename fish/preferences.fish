#!/usr/bin/env fish

# Directories
set -gx WORK_DIR "$HOME/Work" # You are supposed to put your work projects inside a directory named after your company. Example: ~/Work/CompanyName/ProjectName/
set -gx CODING_DIR "$HOME/Coding" # You are supposed to put your personal projects directly in the coding directory. Example: ~/Coding/ProjectName/
set -gx APPS_DIR "$HOME/Applications" # Here we store stuff like AppImages, etc.

# Git external services
set -gx GITHUB_USER "devlulcas" # Your GitHub username
set -gx GITLAB_USER "devlulcas" # Your GitLab username
set -gx CODEBERG_USER "devlulcas" # Your Codeberg username

# Git
set -gx GIT_EDITOR nvim # Editor for Git commits and diffs
set -gx GIT_PAGER less # Display Git logs in a more readable format

# Editor
set -gx PREFERRED_EDITOR code # Preferred editor for code editing
set -gx FALLBACK_EDITOR cursor # Fallback editor if the preferred editor is not available
set -gx TERMINAL_EDITOR nvim # Editor for terminal commands


