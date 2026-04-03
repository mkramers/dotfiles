# Chezmoi Dotfiles

See [README.md](README.md) for conventions, profiles, and shell notes.

- Always `chezmoi apply` after editing source files
- macOS symlinks: configs live in `.config/`, Application Support entries are symlinks
- `.chezmoidata.yaml` holds shared shell config (aliases, env, paths, functions) consumed by both zsh and bash templates
