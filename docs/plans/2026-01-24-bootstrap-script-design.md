# Bootstrap Script Design

Automate dotfiles setup with a single curl | bash command.

## Goal

Replace manual README steps with an idempotent bootstrap script that installs nushell, chezmoi, and aqua, then applies dotfiles.

## Usage

```bash
curl -fsSL https://raw.githubusercontent.com/mkramers/dotfiles/main/bootstrap.sh | bash
```

## Pinned Versions

```bash
NUSHELL_VERSION="0.102.0"
AQUA_VERSION="v2.45.0"
CHEZMOI_VERSION="v2.62.1"
```

## Platform Support

- macOS (arm64, x86_64)
- Linux (arm64, x86_64)

Platform detection via `uname -s` and `uname -m`.

## Idempotency

- Check if tool exists at expected version before downloading
- Use `mkdir -p` for directories
- Downloads go to temp dir, move to `$LOCAL_BIN` on success

## Install Sequence

1. Create `~/.local/bin`
2. Install nushell (from GitHub releases tarball)
3. Install chezmoi (via get.chezmoi.io, then `init --apply mkramers/dotfiles`)
4. Install aqua (via aqua-installer)
5. Post-install:
   - `aqua i -l` (install aqua packages)
   - `ya pack -i` (yazi plugins)
   - Carapace completions setup

## Output

```
[1/5] Creating directories...
[2/5] Installing nushell 0.102.0... (already installed, skipping)
[3/5] Installing chezmoi v2.62.1...
[4/5] Installing aqua v2.45.0...
[5/5] Running post-install setup...

✓ Bootstrap complete!

Launch nushell now? [Y/n]
```

## Error Handling

- `set -euo pipefail` - exit on any error
- Each step prints action before running
- User sees which step failed

## File Changes

| File | Action |
|------|--------|
| `bootstrap.sh` | Create - main bootstrap script |
| `README.md` | Update - replace manual steps with one-liner |
