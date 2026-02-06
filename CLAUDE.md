# Chezmoi Dotfiles

This repo manages dotfiles via [chezmoi](https://www.chezmoi.io/).

## Chezmoi Conventions

- `dot_` prefix → `.` (e.g., `dot_zshrc` → `.zshrc`)
- `private_` prefix → directory/file with restricted permissions; also use for paths with spaces (e.g., `private_Application Support`)
- `symlink_` prefix → creates a symlink (file content is the target path)
- `.tmpl` suffix → template file processed by chezmoi
- Always run `chezmoi apply` after editing files (not just saving to source)

## macOS Config Locations

Some apps ignore `~/.config/` and use `~/Library/Application Support/` instead:

| App | Config Location |
|-----|-----------------|
| lazygit | `~/Library/Application Support/lazygit/` |

Workaround: Create chezmoi-managed symlinks from Application Support to `.config/`.

## Shell Notes

### Zsh
- Prompt tilde: use `${PWD/#$HOME/~}` (no backslash escape needed)
- Unicode glyphs: use `$'\uXXXX'` syntax (e.g., `$'\ue0a0'` for git branch icon)

### Nushell
- 256 colors: `ansi -e '38;5;XXXm'` (the record syntax `ansi { fg: "141" }` doesn't support arbitrary 256 colors)
- Prompt config: `$env.PROMPT_COMMAND` and `$env.PROMPT_INDICATOR`
- Check `~/.config/nushell/vendor/autoload/` for files that may override settings

## Tool Integrations

### lazygit + delta
```yaml
git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never
```

### Terminal Flow Control
Add `stty -ixon` to shell rc to disable XON/XOFF and free Ctrl+S/Q.

### Kitty Keyboard Protocol
Some apps (micro, etc.) may get stuck in Kitty's enhanced keyboard mode. Add escape hatch:
```
map ctrl+shift+escape send_text all \x1bc
```
