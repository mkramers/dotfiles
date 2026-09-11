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
- `run_*` scripts are numbered and run in order: aqua (00/01) → mise (02/03) →
  yazi (04) → zen (05). Guard each on its tool being present so minimal boxes
  skip cleanly

## Traps

- `~/.config/chezmoi/chezmoi.toml` is written by **two** templates that must render
  identical bytes: `.chezmoi.toml.tmpl` (init-only, prompts) and
  `dot_config/chezmoi/private_chezmoi.toml.tmpl` (rewritten every apply). Init templates
  never re-run on `chezmoi update`, so the managed copy is what reaches an existing
  machine. If the two diverge, apply asks "changed since chezmoi last wrote it?" and a
  headless box with no `/dev/tty` aborts on that first file, leaving everything after it
  silently unapplied. Edit both together. To unstick a box, `chezmoi init` regenerates the
  config from the fixed template with no prompts, then apply runs clean.
- `private_dot_ssh/private_authorized_keys.tmpl` renders `authorized_keys` from
  `gitHubKeys`, so every machine that has run `chezmoi apply` already trusts the
  GitHub-published ed25519 key. **The private half is `~/.ssh/github`.** When a managed
  host asks for a password, point its `IdentityFile` there with `IdentitiesOnly yes`
  instead of reaching for `ssh-copy-id`. `~/.ssh/config` is not managed, so host fixes
  live on one machine until that changes.
- Cmd bindings are two layers: kitty.conf passes `\x1b`+char through and zellij binds the
  `Alt+` equivalent, so a new one needs an edit in both files. `macos_option_as_alt yes`
  and `support_kitty_keyboard_protocol false` are what make it work, and a zellij config
  change does not hot-reload into an existing session.
