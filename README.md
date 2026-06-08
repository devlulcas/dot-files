# DOT FILES

Some configs and scripts that I use.
Enjoy!

## Fresh Environment

```sh
git clone git@github.com:devlulcas/dot-files.git ~/.dotfiles
cd ~/.dotfiles
fish ./setup.fish
```

Run a health check after opening a new shell:

```sh
dotfiles doctor
```

Expected local directories:

- `~/Work` for work projects, usually grouped by company.
- `~/Coding` for personal projects.
- `~/Applications` for AppImages, raw binaries, and manually installed tools.

`init.fish` is kept as a compatibility wrapper around `setup.fish`.

## Based on

- [antfu](https://www.github.com/antfu)
- [koekeishiya](https://github.com/koekeishiya/dotfiles/tree/master)
