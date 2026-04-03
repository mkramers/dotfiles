# dotfiles

Cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io/).

- Two profiles: **full** (macOS, zsh, GUI apps) and **minimal** (bash, no sudo)
- Tools via [aqua](https://aquaproj.github.io/) (JIT single binaries) and [mise](https://mise.jdx.dev/) (eza)
- Shared shell config (aliases, env, paths, functions) across zsh and bash via chezmoi templates
- macOS app configs in `~/.config/` with symlinks from `~/Library/Application Support/`

## Install

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply mkramers/dotfiles
```

Prompts for profile on first init.
