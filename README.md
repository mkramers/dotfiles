# dotfiles

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mkramers/dotfiles
```

## Chezmoi Conventions

- `dot_` prefix → `.` (e.g., `dot_zshrc` → `.zshrc`)
- `private_` prefix → restricted permissions; also for paths with spaces (e.g., `private_Application Support`)
- `symlink_` prefix → creates a symlink (file content is the target path)
- `.tmpl` suffix → template file processed by chezmoi

## Profiles

Set at `chezmoi init` time via the `profile` data field:

- **full** — zsh, GUI apps, all aqua packages (macOS workstation)
- **minimal** — bash, core CLI tools only (e.g. slurm login nodes, no sudo)

## macOS App Config

Some apps use `~/Library/Application Support/` instead of `~/.config/`. We store configs in `.config/` and symlink from Application Support:

| App | Symlink |
|-----|---------|
| k9s | `Library/Application Support/k9s` → `../../.config/k9s` |
| lazygit | `Library/Application Support/lazygit` → `../../.config/lazygit` |

## Shell Notes

- Prompt tilde: `${PWD/#$HOME/~}` (no backslash escape)
- Unicode glyphs: `$'\uXXXX'` syntax
- `stty -ixon` in rc to free Ctrl+S/Q
- Kitty keyboard escape hatch: `map ctrl+shift+escape send_text all \x1bc`
