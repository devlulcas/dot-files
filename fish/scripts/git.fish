#!/usr/bin/env fish

set -l gremcheck_desc "Fetches a specific remote branch from 'origin' and checks it out as a new local branch tracking the remote."
function gremcheck --description $gremcheck_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="gremcheck <branch-name>" \
            --description=$gremcheck_desc \
            --dependency="git" \
            --example="gremcheck feature/new-flow"
        return
    end

    __require_git_repo or return
    __require_arg "branch-name" "$argv[1]" or return

    set -l branch $argv[1]

    echo "Fetching branch '$branch' from origin..."
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    and git fetch origin "$branch"
    and git switch -c "$branch" "origin/$branch"
    or begin
        __error "Error fetching branch '$branch'."
        return 1
    end

    echo "Successfully checked out branch '$branch'."
end

set -l gundo_desc "Undoes the most recent commit, keeping the changes in the staging area."
function gundo --description $gundo_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="gundo" \
            --description=$gundo_desc \
            --dependency="git"
        return
    end

    __require_git_repo or return
    git rev-parse --verify HEAD~1 >/dev/null 2>/dev/null
    or begin
        __error "HEAD~1 does not exist. There is no previous commit to reset to."
        return 1
    end

    echo "Undoing the last commit (keeping changes staged)..."
    git reset --soft HEAD~1
    if test $status -ne 0
        __error "Error undoing the last commit."
        return 1
    end
    echo "Last commit undone. Changes are still staged."
end

set -l gclean_desc "Deletes local Git branches merged into current branch, excluding 'master', 'main', and the current branch."
function gclean --description $gclean_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="gclean" \
            --description=$gclean_desc \
            --dependency="git"
        return
    end

    __require_git_repo or return

    echo "Deleting merged local branches (excluding *, master, main)..."
    set -l branches (git branch --merged | string trim | string match -rv '^(\* )?(main|master)$' | string match -rv '^\*')

    if test (count $branches) -eq 0
        echo "No merged local branches to delete."
        return 0
    end

    for branch in $branches
        git branch -d "$branch"
        if test $status -ne 0
            __error "Could not delete branch '$branch'. It may have unmerged changes."
            return 1
        end
    end

    echo "Merged branches cleaned."
end
