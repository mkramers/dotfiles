# dotfiles

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply mkramers/dotfiles
```

Prompts for profile on first init:

- **full** — zsh, GUI apps, all aqua packages (macOS workstation)
- **minimal** — bash, core CLI tools only (e.g. slurm login nodes, no sudo)

## macOS App Config

Configs live in `~/.config/`, with symlinks from `~/Library/Application Support/` for apps that require it:

| App | Symlink |
|-----|---------|
| k9s | `Library/Application Support/k9s` → `../../.config/k9s` |
| lazygit | `Library/Application Support/lazygit` → `../../.config/lazygit` |
