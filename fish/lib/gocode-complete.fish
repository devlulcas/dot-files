function __gocode_complete
    # Use global variables if available, fallback to hardcoded paths
    set -l coding_dir (test -n "$CODING_DIR"; and echo "$CODING_DIR"; or echo "$HOME/Coding")
    set -l work_dir (test -n "$WORK_DIR"; and echo "$WORK_DIR"; or echo "$HOME/Work")
    
    ls -d $coding_dir/*/ $work_dir/*/*/ 2>/dev/null | xargs -n1 basename
end