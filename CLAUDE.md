# Chezmoi Dotfiles

See [README.md](README.md) for install, profiles, and shell notes. This file is itself
chezmoi-managed and deploys to `~/CLAUDE.md` — edit it here, not there.

## Workflow

- Edit source files here (`dot_config/...`), never live files (`~/.config/...`)
- `chezmoi diff` before `chezmoi apply`. Use `--force` only to bypass the TTY error in
  non-interactive shells — not as a default
- Work lands directly on `main`; no feature branch or PR for this repo

## Layout

- `.chezmoidata.yaml` holds shared shell config (aliases, env, paths, functions).
  Templates are **zsh-only** — `dot_bash_profile` just `exec`s zsh on login
- macOS: configs live in `.config/`; Application Support entries are symlinks
- `dot_aqua/aqua.yaml.tmpl` — packages above the full-profile block install on every
  profile; those inside it are macOS/GUI tier only
- `run_*` scripts are numbered and run in order: aqua (00/01) → mise (02/03) → yazi (04).
  Guard each on its tool being present so minimal boxes skip cleanly
