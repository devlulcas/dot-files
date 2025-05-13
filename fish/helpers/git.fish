
function gremcheck --description "Fetches a specific remote branch from 'origin' and immediately checks it out as a new local branch with the same name, tracking the remote branch" 
    if test (count $argv) -ne 1
        echo "Usage: gremcheck <branch-name>" >&2
        return 1
    end

    set branch $argv[1]

    echo "Fetching branch '$branch' from origin..."
    git fetch origin $branch
    if test $status -ne 0
        echo "Error fetching branch '$branch'." >&2
        return 1
    end

    echo "Checking out branch '$branch' as a new local branch..."
    git checkout -b $branch origin/$branch
    if test $status -ne 0
        echo "Error checking out branch '$branch'." >&2
        return 1
    end
    echo "Successfully checked out branch '$branch'."
end

function gundo --description "Undoes the most recent commit, keeping the changes in the staging area"
    echo "Undoing the last commit (keeping changes staged)..."
    git reset --soft HEAD~1
    if test $status -ne 0
        echo "Error undoing the last commit." >&2
        return 1
    end
    echo "Last commit undone. Changes are still staged."
end

function gclean --description "Deletes local Git branches that have been merged into the current branch, excluding 'master' and 'main', and the currently active branch"
    echo "Deleting merged local branches (excluding *, master, main)..."
    git branch --merged | grep -vE '^\*|master|main' | xargs -r -n 1 git branch -d
    if test $status -ne 0
        echo "Note: Some branches may not have been deleted if they have unmerged changes." >&2
        # Return 0 even if some branches weren't deleted, unless grep or xargs failed critically
        set cmd_status $status
        if test $cmd_status -eq 123 # xargs exit status for command not found
             return 1
        end
        if test $cmd_status -eq 127 # grep exit status for command not found
            return 1
        end
        # Otherwise, assume the non-zero status was from git branch -d on unmerged branches
        return 0
    end
    echo "Merged branches cleaned."
end

function gstashpop --description "Applies the most recent stash and then shows the resulting differences" 
    echo "Applying the most recent stash and showing diff..."
    git stash pop
    and git diff
    if test $status -ne 0
         echo "Note: git stash pop may have resulted in conflicts. Please resolve them." >&2
         return 1
    end
    echo "Stash applied."
end
