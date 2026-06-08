#!/usr/bin/env fish

set -l repo_dir (realpath (status dirname))
fish "$repo_dir/setup.fish" $argv
