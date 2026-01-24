# dotfiles

```bash
curl -fsSL https://raw.githubusercontent.com/mkramers/dotfiles/main/bootstrap.sh | bash
```

This installs nushell, chezmoi, aqua, and applies all dotfiles.

---

## Verified Install (optional)

For security-conscious installs, you can verify signatures before running.

### Chezmoi

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

sha256sum --check chezmoi_2.62.1_checksums.txt --ignore-missing

rm -r chezmoi_*
chezmoi init --apply mkramers/dotfiles
```

### Aqua

```bash
cd ~/.local/bin

curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.1.1/aqua-installer
echo "e9d4c99577c6b2ce0b62edf61f089e9b9891af1708e88c6592907d2de66e3714  aqua-installer" | sha256sum -c -

chmod +x aqua-installer
./aqua-installer
rm aqua-installer
```
