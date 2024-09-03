### Bootstrap
- [Install brew](https://brew.sh/):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
```