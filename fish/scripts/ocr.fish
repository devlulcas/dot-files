#!/usr/bin/env fish
# Dependencies: tesseract wl-clipboard

function ocr
      set -l OCR (mktemp)
      set -l icon /usr/share/icons/Adwaita/symbolic/actions/edit-copy-symbolic.svg
      set -l title "OCR Script"

      # get the last screenshot
      set -l last_screenshot (find ~/Pictures/Screenshots/ -maxdepth 1 -mindepth 1 -type f -exec stat -c '%y %n' {} + | sort -r | head -1 | cut -d' ' -f4-)

      # does ocr using tesseract
      tesseract -l eng $last_screenshot $OCR
      set -l ocr_content (cat $OCR.txt)

      if test -z "$ocr_content"
            notify-send -i $icon -a $title "Last screenshot had no text" "For $last_screenshot"
      else
            echo $ocr_content | sed -z '$ s/\n$//' | wl-copy
            notify-send -i $icon -a $title 'Last screenshot text copied' "$ocr_content\nFor $last_screenshot"
      end
end