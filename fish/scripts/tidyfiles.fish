#!/usr/bin/env fish

function tidyfiles
    set -l usage "Usage: tidyfiles [--dry-run|-n] [--verbose|-v] [--all|-a]"
    set -l desc "Organizes items in the current directory into Images, Music, Videos, PDFs, Texts, Markdown, Code, SubDirs, and Unknown. By default, hidden files/dirs are skipped (use --all to include)."

    if show_help "$usage" "$desc" $argv[1]
        return
    end

    set -l dry_run 0
    set -l verbose 0
    set -l include_hidden 0

    for arg in $argv
        switch $arg
            case --dry-run -n
                set dry_run 1
            case --verbose -v
                set verbose 1
            case --all -a
                set include_hidden 1
        end
    end

    set -l categories Images Music Videos PDFs Texts Markdown Code SubDirs Unknown

    set -l cat_images jpg jpeg png gif webp svg bmp tif tiff heic heif avif ico
    set -l cat_music mp3 m4a flac wav ogg oga aac opus wma mid midi
    set -l cat_videos mp4 mkv mov avi webm mpeg mpg m4v 3gp 3g2
    set -l cat_pdfs pdf
    set -l cat_texts txt log csv tsv ini cfg conf env json jsonl yaml yml xml toml properties
    set -l cat_markdown md markdown rmd
    set -l cat_code js mjs cjs ts tsx jsx py rb go rs java kt swift cs php sh bash zsh fish ps1 psm1 psd1 c cpp cc cxx h hpp hh hxx mm m scala sql lua pl pm r ipynb html htm css scss less vue svelte astro dart zig nim elv

    function _is_hidden --argument-names name
        set -l base (basename -- $name)
        if test (string sub -s 1 -l 1 -- $base) = '.'
            return 0
        end
        return 1
    end

    function _ensure_dirs --argument-names dry_run_flag
        set -l dirs $argv[2..-1]
        for d in $dirs
            if test ! -d "$d"
                if test "$dry_run_flag" -eq 1
                    echo "[dry-run] mkdir -p -- '$d'"
                else
                    mkdir -p -- "$d"
                end
            end
        end
    end

    function _ext_of --argument-names filename
        set -l base (basename -- $filename)
        set -l ext (string match -r -g '.*\.([^.]+)$' -- $base)
        if test -n "$ext"
            echo (string lower -- $ext)
        end
    end

    function _filename_parts --argument-names filename
        set -l base (basename -- $filename)
        set -l name_no_ext (string replace -r '(\.[^.]*)$' '' -- $base)
        set -l dot_ext (string match -r -g '(\.[^.]*)$' -- $base)
        echo $name_no_ext
        echo $dot_ext
    end

    function _unique_dest --argument-names target_dir filename
        set -l parts (_filename_parts $filename)
        set -l name_no_ext $parts[1]
        set -l dot_ext $parts[2]

        set -l candidate "$target_dir/$filename"
        set -l idx 1
        while test -e "$candidate"
            set candidate "$target_dir/$name_no_ext ($idx)$dot_ext"
            set idx (math $idx + 1)
        end
        echo $candidate
    end

    function _is_category_dir --argument-names name
        set -l cats $argv[2..-1]
        for d in $cats
            if test "$name" = "$d"
                return 0
            end
        end
        return 1
    end

    function _is_code_named_file --argument-names filename
        set -l base (basename -- $filename)
        switch $base
            case Makefile Dockerfile 'CMakeLists.txt' Gemfile Rakefile Justfile Procfile
                return 0
        end
        return 1
    end

    _ensure_dirs $dry_run $categories

    set -l items *
    if test (count $items) -eq 1; and test "$items[1]" = '*'
        set -e items
    end
    if test $include_hidden -eq 1
        set -l hidden .*
        if test (count $hidden) -eq 1; and test "$hidden[1]" = '.*'
            set -e hidden
        end
        set items $items $hidden
    end

    if test (count $items) -eq 0
        echo "Nothing to organize in" (pwd)"."
        return 0
    end

    for it in $items
        if test "$it" = '.' -o "$it" = '..'
            continue
        end

        if test $include_hidden -eq 0
            if _is_hidden $it
                continue
            end
        end

        set -l base (basename -- $it)
        if not test -e "$it"
            continue
        end

        set -l category ''
        if test -d "$it"
            if _is_category_dir $base $categories
                if test $verbose -eq 1
                    echo "Skipping category directory: $base"
                end
                continue
            end
            set category SubDirs
        else
            set -l ext (_ext_of $it)
            if test -n "$ext"
                if contains -- $ext $cat_images
                    set category Images
                else if contains -- $ext $cat_music
                    set category Music
                else if contains -- $ext $cat_videos
                    set category Videos
                else if contains -- $ext $cat_pdfs
                    set category PDFs
                else if contains -- $ext $cat_markdown
                    set category Markdown
                else if contains -- $ext $cat_texts
                    set category Texts
                else if contains -- $ext $cat_code
                    set category Code
                else
                    set category Unknown
                end
            else
                if _is_code_named_file $it
                    set category Code
                else
                    set category Unknown
                end
            end
        end

        set -l dest_dir $category
        set -l dest (_unique_dest $dest_dir $base)

        if test $dry_run -eq 1
            echo "[dry-run] mv -- '"$it"' '"$dest"'"
        else
            if test $verbose -eq 1
                echo "Moving '"$it"' -> '"$dest"'"
            end
            mv -- "$it" "$dest"
        end
    end
end
