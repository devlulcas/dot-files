#!/usr/bin/env fish

set -l update_desc "Update fedora packages and clean up"
function update --description $update_desc
  sudo dnf -y autoremove
  sudo dnf -y clean all
  sudo dnf -y makecache
  sudo flatpak -y update
  sudo dnf upgrade --refresh --best
  flatpak uninstall --unused
end
