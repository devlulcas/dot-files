#!/usr/bin/env fish
# Dependencies: tesseract wl-clipboard

set -l ocr_desc "Extracts text from the last screenshot and copies it to the clipboard."
function ocr --description $ocr_desc
    argparse 'h/help' -- $argv or return

    if set -ql _flag_help
        help-view \
            --usage="ocr" \
            --description=$ocr_desc \
            --dependency="tesseract" \
            --dependency="wl-copy" \
            --dependency="notify-send" \
            --example="ocr"
        return
    end

    __require_command tesseract or return
    __require_command wl-copy or return

    set -l screenshot_dir "$HOME/Pictures/Screenshots"
    if not test -d "$screenshot_dir"
        __error "Screenshot directory does not exist: $screenshot_dir"
        return 1
    end

    set -l OCR (mktemp)
    set -l icon /usr/share/icons/Adwaita/symbolic/actions/edit-copy-symbolic.svg
    set -l title "OCR Script"

    set -l latest_line (find "$screenshot_dir" -maxdepth 1 -mindepth 1 -type f -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -1)
    if test -z "$latest_line"
        __error "No screenshots found in $screenshot_dir"
        return 1
    end

    set -l last_screenshot (string split -m 1 ' ' -- "$latest_line")[2]
    if test -z "$last_screenshot"
        __error "Could not determine the latest screenshot"
        return 1
    end

    tesseract -l eng "$last_screenshot" "$OCR" >/dev/null 2>/dev/null
    or begin
        __error "tesseract failed for $last_screenshot"
        rm -f "$OCR" "$OCR.txt"
        return 1
    end

    set -l ocr_content (string collect <"$OCR.txt")
    rm -f "$OCR" "$OCR.txt"

    if test -z "$ocr_content"
        if command -q notify-send
            notify-send -i $icon -a $title "Last screenshot had no text" "For $last_screenshot"
        end
    else
        printf "%s" "$ocr_content" | wl-copy
        if command -q notify-send
            notify-send -i $icon -a $title 'Last screenshot text copied' "$ocr_content\nFor $last_screenshot"
        end
    end
end
