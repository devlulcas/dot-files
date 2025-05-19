function show_help
    set -l usage "Usage: show_help <usage-string> <description> [arg]"
    set -l desc "Displays help information if the third argument is --help or -h."

    if test "$argv[1]" = "--help" -o "$argv[1]" = "-h"
        echo "$usage\n$desc"
        return 0
    end

    if test "$argv[3]" = "--help" -o "$argv[3]" = "-h"
        echo "$argv[1]\n$argv[2]"
        return 0
    end

    return 1
end
