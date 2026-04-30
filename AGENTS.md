# Repository notes for agents

Personal macOS dotfiles. Deployed via GNU Stow from the repo root: every path under the root (notably `.config/**`) is symlinked into `$HOME` by `stow .`.

## Layout

- `install` — 1-line entrypoint; real logic in `.config/bin/dotfiles`
- `.config/bin/dotfiles` — installer: Homebrew, git submodules, `stow .`, `osxdefaults`, optional `~/init_script`
- `other/lib/{help,list,misc,utils}` — sourced by the installer; `run_misc_packages` in `misc` installs npm globals, bun, rust, wezterm terminfo
- `Brewfile` — Homebrew packages (root, not stowed)
- `.config/opencode/` — OpenCode config, agents, skills, plugins. `opencode.json` sets prettier overrides (`--no-semi --single-quote --no-bracket-spacing --print-width 80`) and loads `~/.config/opencode/rules.md` as global instructions (TS/JS style rules live there — don't duplicate).

## Stow gotchas

- The repo IS the source of truth; files in `$HOME/.config/...` are usually symlinks back here. Edit the file in this repo, not the symlink target.
- `.stow-local-ignore` excludes top-level files from being linked into `$HOME` (`README*`, `Brewfile`, `other`, `install`, `AGENTS.md`). Any new top-level file that should NOT appear in `$HOME` must be added there.
- Running `bash install` or `dotfiles` is destructive: it re-stows, may back up `~/.zshrc` / `~/.zshenv` to `.bak`, and runs `osxdefaults`. Do not run during routine edits.

## Commands

- Install / re-link: `bash install` (first time) or `dotfiles` (after).
- Skip packages / sync: `dotfiles --no-packages`, `dotfiles --no-sync`.
- Submodules: `git submodule update --recursive --init` (needed for `other/images/wallpapers/wallpapper`).
- No tests, lint, typecheck, or CI in this repo.

## Conventions

- Branch names: `gonza/<branch-name>` (see `.config/opencode/skills/create-branch/SKILL.md`).
- `.go` files in `.config/bin/` are installed via `go install <file>` by the installer loop at the end of `.config/bin/dotfiles` (file-based, not module-based).
