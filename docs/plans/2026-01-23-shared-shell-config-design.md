# Shared Shell Config Design

Consolidate nushell and zsh configuration into a single source of truth using chezmoi's `.chezmoidata.yaml`.

## Problem

Nushell and zsh configs duplicate paths, env vars, aliases, and functions. Changes require manual syncing between files.

## Solution

Create `.chezmoidata.yaml` with shared shell configuration. Both shell config templates read from this data and generate shell-appropriate syntax.

## Data Structure

```yaml
shell:
  paths:
    - path: /usr/local/bin
    - path: .local/bin
      relative: true
    - path: .local/share/aquaproj-aqua/bin
      relative: true
    - path: /Applications/Sublime Text.app/Contents/SharedSupport/bin
      os: darwin

  env:
    AQUA_POLICY_CONFIG: .aqua/aqua-policy.yaml
    EDITOR: nano  # relies on alias nano=micro for fallback
    FZF_DEFAULT_COMMAND: fd --type file --color=always
    FZF_CTRL_T_COMMAND: $FZF_DEFAULT_COMMAND
    GIT_PAGER:
      value: delta
      check: delta
      fallback: less

  aliases:
    ll: ls -la
    nano: micro
    cat: bat
    s: kitten ssh
    y: yazi
    tre: tre -a
    lzg: lazygit
    k9s-kflow: aws-vault exec admin-kflow -- k9s

  functions:
    paws:
      description: print AWS env vars
      nu: $env | transpose key value | where key =~ "AWS" | format pattern '{key}={value}' | to text
      zsh: env | grep AWS
    cdg:
      description: cd to git root
      nu: cd (git rev-parse --show-toplevel)
      zsh: cd "$(git rev-parse --show-toplevel)"
```

## Template Logic

Templates iterate over shared data and generate shell-specific syntax:

- **Paths**: Filter by `os` field, expand `relative: true` with HOME
- **Env vars**: Simple key=value, or if map with `check`/`fallback`, generate conditional
- **Aliases**: Direct mapping with shell-appropriate syntax
- **Functions**: Use `nu` or `zsh` field based on target shell

## File Changes

| File | Action |
|------|--------|
| `.chezmoidata.yaml` | Create - shared shell config data |
| `dot_zshrc` -> `dot_zshrc.tmpl` | Rename and rewrite as template |
| `.chezmoitemplates/nushell/config.nu` | Update to read from shared data |
| `dot_aqua/aqua.yaml` | Clean up duplicate package entries |

## Shell-Specific Items (stay in templates)

**Nushell only:**
- `devpod` wrapper function
- `confignu` alias
- fnm module import
- `$env.config.show_banner`, `$env.config.buffer_editor`

**Zsh only:**
- Prompt configuration
- History settings
- Completion setup
- `configzsh` alias
- Color settings

## Fallback Strategy

- `EDITOR=nano` with `alias nano=micro` provides resilience - if aqua/micro unavailable, real nano works
- `GIT_PAGER` uses explicit check/fallback to handle missing delta
