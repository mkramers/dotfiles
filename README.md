# dotfiles

Cross-platform dotfiles managed with [`chezmoi`](https://www.chezmoi.io/).

- Two profiles (selected on `chezmoi init`): **full** (`macOS`, `zsh`, GUI apps) and **minimal** (`zsh`, core CLI tools, no sudo)
- Tools via [`aqua`](https://aquaproj.github.io/) (JIT single binaries) and [`mise`](https://mise.jdx.dev/) (`eza`)
- `macOS` app configs in `~/.config/` with symlinks from `~/Library/Application Support/`

## Install

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply mkramers/dotfiles
```
