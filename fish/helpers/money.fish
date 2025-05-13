function money
    set -l python_script_path "$HOME/.dotfiles/tiny/money.py"

    # Check if the Python script exists
    if not test -f "$python_script_path"
        echo "Error: Python script not found at $python_script_path" >&2
        echo "Please edit money.fish and set the correct path." >&2
        exit 1
    end

    # Check the command-line arguments passed to the fish script
    if test (count $argv) -gt 0
        set -l command $argv[1]

        switch "$command"
            case "register"
                # Call the Python script with the 'register' argument
                python3 "$python_script_path" register
            case "see"
                # Call the Python script with the 'see' argument
                python3 "$python_script_path" see
            case "*"
                # Handle unknown arguments
                echo "Usage: money [register|see]"
                exit 1
        end
    else
        # No arguments provided, call the Python script for data input
        python3 "$python_script_path"
    end
end