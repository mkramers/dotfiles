# dotfiles

Cross-platform dotfiles managed with [`chezmoi`](https://www.chezmoi.io/).

- Two profiles (selected on `chezmoi init`): **full** (`macOS`, `zsh`, GUI apps) and **minimal** (`zsh`, core CLI tools, no sudo)
- Tools via [`aqua`](https://aquaproj.github.io/) (JIT single binaries) and [`mise`](https://mise.jdx.dev/) (`eza`)
- `macOS` app configs in `~/.config/` with symlinks from `~/Library/Application Support/`

## Install

Install the `chezmoi` binary first, then initialize as a separate step. Splitting
the two avoids a mangled prompt when `init`'s interactive questions run inside the
`curl | sh` bootstrap on minimal consoles (e.g. fresh containers):

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
~/.local/bin/chezmoi init --apply mkramers/dotfiles
```

`init` prompts for email, GitHub username, and profile. To provision non-interactively
(no prompts, and skip the "config has changed" question on re-runs), pass them up front:

```bash
~/.local/bin/chezmoi init --apply --force \
  --promptString email=you@example.com \
  --promptString github_username=you \
  --promptChoice profile=minimal \
  mkramers/dotfiles
```

The binary installs to `~/.local/bin`; add it to `PATH` (`export PATH="$HOME/.local/bin:$PATH"`)
if it isn't already. On a Linux box that only ships `bash`, install `zsh` first
(`apt-get install -y zsh`) — both profiles are zsh-based, and `~/.bash_profile` hands off
to zsh on login.
