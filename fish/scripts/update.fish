#!/usr/bin/env fish

set -l update_desc "Update fedora packages and clean up"
function update --description $update_desc
    argparse 'h/help' 'a/all' 'd/dnf' 'f/flatpak' 'n/dry-run' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="update [--all] [--dnf] [--flatpak] [--dry-run]" \
            --description=$update_desc \
            --dependency="dnf" \
            --dependency="flatpak" \
            --opt="a/all Run all update steps. This is the default." \
            --opt="d/dnf Run only Fedora/dnf update steps." \
            --opt="f/flatpak Run only Flatpak update steps." \
            --opt="n/dry-run Print the commands that would run." \
            --example="update" \
            --example="update --dnf" \
            --example="update --flatpak --dry-run"
        return
    end

    set -l run_dnf 0
    set -l run_flatpak 0

    if set -ql _flag_dnf
        set run_dnf 1
    end

    if set -ql _flag_flatpak
        set run_flatpak 1
    end

    if set -ql _flag_all
        set run_dnf 1
        set run_flatpak 1
    end

    if test $run_dnf -eq 0; and test $run_flatpak -eq 0
        set run_dnf 1
        set run_flatpak 1
    end

    set -l dry_run no
    if set -ql _flag_dry_run
        set dry_run yes
    end

    if test $run_dnf -eq 1
        __require_command sudo or return
        __require_command dnf or return
        __run_or_print $dry_run sudo dnf -y autoremove
        and __run_or_print $dry_run sudo dnf -y clean all
        and __run_or_print $dry_run sudo dnf -y makecache
        and __run_or_print $dry_run sudo dnf upgrade --refresh --best
        or return
    end

    if test $run_flatpak -eq 1
        __require_command flatpak or return
        __run_or_print $dry_run flatpak -y update
        and __run_or_print $dry_run flatpak uninstall --unused
        or return
    end
end

function __run_or_print --description "Run a command, or print it when dry-run is set"
    set -l dry_run $argv[1]
    set -l command_parts $argv[2..-1]

    if test "$dry_run" = yes
        echo (string join " " $command_parts)
        return 0
    end

    $command_parts
end

complete -c update -f
complete -c update -s a -l all -d "Run all update steps"
complete -c update -s d -l dnf -d "Run Fedora/dnf update steps"
complete -c update -s f -l flatpak -d "Run Flatpak update steps"
complete -c update -s n -l dry-run -d "Print commands without running them"
