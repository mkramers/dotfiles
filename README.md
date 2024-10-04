### Bootstrap
- [Install brew](https://brew.sh/):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

- [Install oh-my-zsh](https://ohmyz.sh/#install):
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

- [Install stow](https://www.gnu.org/software/stow/)
```bash
brew install stow
```

- [Install pyenv](https://github.com/pyenv/pyenv?tab=readme-ov-file#unixmacos):
```bash
brew update
brew install pyenv

# install python version
pyenv install 3.11.6
```

- [Install pipenv](https://pipenv.pypa.io/en/latest/installation.html#installing-pipenv):
```bash
pip install pipenv --user
```

- [Install just](https://just.systems/man/en/chapter_4.html):
```bash
brew install just
```

- [Install nvm](https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script):
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# install node v16.15.1
nvm install v16.15.1
nvm use v16.15.1
```

- [Install yarn](https://yarnpkg.com/getting-started/install):
```bash
corepack enable
```

- Install utils:
```bash
# eza - better ls
brew install eza

# bat - better cat (https://github.com/sharkdp/bat?tab=readme-ov-file#installation)
brew install bat

# fzf - fuzzy search
brew install fzf

# zoxide - better cd (https://github.com/ajeetdsouza/zoxide)
brew install zoxide

# github cli
brew install gh

# aws cli
brew install awscli

# poetry
curl -sSL https://install.python-poetry.org | python3 -

# jq
brew install jq

# yazi
brew install yazi ffmpegthumbnailer sevenzip poppler fd ripgrep imagemagick font-symbols-only-nerd-font

# oh-my-zsh plugins
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
brew install zsh-autosuggestions
```
