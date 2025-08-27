function gremcheck
    set -l usage "Usage: gremcheck <branch-name>"
    set -l desc "Fetches a specific remote branch from 'origin' and checks it out as a new local branch tracking the remote."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    set branch $argv[1]

    echo "Fetching branch '$branch' from origin..."
    git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git fetch origin $branch
    git switch -c $branch origin/$branch

    if test $status -ne 0
        echo "Error fetching branch '$branch'." >&2
        return 1
    end

    echo "Successfully checked out branch '$branch'."
end

function gundo
    set -l usage "Usage: gundo"
    set -l desc "Undoes the most recent commit, keeping the changes in the staging area."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    echo "Undoing the last commit (keeping changes staged)..."
    git reset --soft HEAD~1
    if test $status -ne 0
        echo "Error undoing the last commit." >&2
        return 1
    end
    echo "Last commit undone. Changes are still staged."
end

function gclean
    set -l usage "Usage: gclean"
    set -l desc "Deletes local Git branches merged into current branch, excluding 'master', 'main', and the current branch."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    echo "Deleting merged local branches (excluding *, master, main)..."
    git branch --merged | grep -vE '^\*|master|main' | xargs -r -n 1 git branch -d
    if test $status -ne 0
        echo "Note: Some branches may not have been deleted if they have unmerged changes." >&2
        # Return 0 even if some branches weren't deleted, unless grep or xargs failed critically
        set cmd_status $status
        if test $cmd_status -eq 123  # xargs command failure
            return 1
        end
        if test $cmd_status -eq 127  # grep command failure
            return 1
        end
        # Otherwise, assume failure is due to unmerged branches - do not treat as error
        return 0
    end

    echo "Merged branches cleaned."
end

function gstashpop
    set -l usage "Usage: gstashpop"
    set -l desc "Applies the most recent stash and then shows the resulting differences."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    echo "Applying the most recent stash and showing diff..."
    git stash pop
    and git diff
    if test $status -ne 0
        echo "Note: git stash pop may have resulted in conflicts. Please resolve them." >&2
        return 1
    end
    echo "Stash applied."
end
