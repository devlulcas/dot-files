function cursor --description "Launch Cursor code editor"
    set -l cursor_app "$HOME/Applications/Cursor/cursor.AppImage"
    
    # Check if the AppImage exists
    if not test -f "$cursor_app"
        echo "Error: Cursor AppImage not found at $cursor_app"
        return 1
    end
    
    # Make sure it's executable
    if not test -x "$cursor_app"
        echo "Making Cursor AppImage executable..."
        chmod +x "$cursor_app"
    end
    
    # Launch Cursor with arguments
    if test (count $argv) -eq 0
        # No arguments - open current directory
        "$cursor_app" . &>/dev/null &
        disown
    else
        # Pass all arguments to Cursor
        "$cursor_app" $argv &>/dev/null &
        disown
    end
end