# dotfiles

### In bash/zsh...

```bash
mkdir ~/.local/bin
cd ~/.local/bin

# get nushell --------------------
# find appropriate release from https://github.com/nushell/nushell/releases
curl -sL <url> | tar --strip-components 1 -xvzf - */nu

# get chezmoi - see below for verified install --------------------
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply mkramers/dotfiles

#get aqua - see below for verified install --------------------
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.1.1/aqua-installer | bash

# launch nushell
~/.local/bin/nu
```

### In nu...

```bash
# download binaries --------------------
aqua i -l
# OR
gh auth login
$env.GITHUB_TOKEN = gh auth token
aqua i
gh auth logout

# misc apps --------------------
ya pack -i

#https://carapace-sh.github.io/carapace-bin/setup.html#nushell
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
source ~/.cache/carapace/init.nu
```

## Misc

### Chezmoi Verified Install

```bash
cd ~/.local/bin

# requires cosign
curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"
mv cosign-linux-amd64 cosign
chmod +x cosign

# verify chezmoi
curl --location --remote-name-all \
       https://github.com/twpayne/chezmoi/releases/download/v2.62.1/chezmoi_2.62.1_checksums.txt \
       https://github.com/twpayne/chezmoi/releases/download/v2.62.1/chezmoi_2.62.1_checksums.txt.sig \
       https://github.com/twpayne/chezmoi/releases/download/v2.62.1/chezmoi_cosign.pub

./cosign verify-blob --key=chezmoi_cosign.pub \
                     --signature=chezmoi_2.62.1_checksums.txt.sig \
                     chezmoi_2.62.1_checksums.txt
# cosign should print "Verified OK"

sha256sum --check chezmoi_2.62.1_checksums.txt --ignore-missing
# confirm verified

# cleanup
rm -r chezmoi_*

# optional
rm ./cosign

# init dotfiles from GH
chezmoi init --apply mkramers/dotfiles
```

### Aqua Verified Install

```bash
cd ~/.local/bin

curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.1.1/aqua-installer

echo "e9d4c99577c6b2ce0b62edf61f089e9b9891af1708e88c6592907d2de66e3714  aqua-installer" | sha256sum -c -
# confirm verified

chmod +x aqua-installer
./aqua-installer

# cleanup
rm aqua-installer
```
