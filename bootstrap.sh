#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles Bootstrap Script
# Usage: curl -fsSL https://raw.githubusercontent.com/mkramers/dotfiles/main/bootstrap.sh | bash
# =============================================================================

# Pinned versions
NUSHELL_VERSION="0.102.0"
CHEZMOI_VERSION="2.62.1"
AQUA_VERSION="v2.45.0"

# Paths
LOCAL_BIN="$HOME/.local/bin"
AQUA_BIN="$HOME/.local/share/aquaproj-aqua/bin"

# Colors (if terminal supports them)
if [[ -t 1 ]]; then
    GREEN='\033[0;32m'
    YELLOW='\033[0;33m'
    RED='\033[0;31m'
    NC='\033[0m'
else
    GREEN=''
    YELLOW=''
    RED=''
    NC=''
fi

# Detect platform
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Normalize architecture names
case "$ARCH" in
    arm64)  ARCH="aarch64" ;;
    amd64)  ARCH="x86_64" ;;
esac

step() {
    echo -e "${GREEN}[$1]${NC} $2"
}

skip() {
    echo -e "${YELLOW}      (already installed, skipping)${NC}"
}

error() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# =============================================================================
# Step 1: Create directories
# =============================================================================
step "1/5" "Creating directories..."
mkdir -p "$LOCAL_BIN"

# =============================================================================
# Step 2: Install nushell
# =============================================================================
step "2/5" "Installing nushell $NUSHELL_VERSION..."

if [[ -x "$LOCAL_BIN/nu" ]] && "$LOCAL_BIN/nu" --version 2>/dev/null | grep -q "$NUSHELL_VERSION"; then
    skip
else
    case "$OS" in
        darwin) NU_PLATFORM="${ARCH}-apple-darwin" ;;
        linux)  NU_PLATFORM="${ARCH}-unknown-linux-gnu" ;;
        *)      error "Unsupported OS: $OS" ;;
    esac

    NU_URL="https://github.com/nushell/nushell/releases/download/${NUSHELL_VERSION}/nu-${NUSHELL_VERSION}-${NU_PLATFORM}.tar.gz"

    TMPDIR=$(mktemp -d)
    trap "rm -rf $TMPDIR" EXIT

    curl -fsSL "$NU_URL" | tar -xzf - -C "$TMPDIR" --strip-components=1
    mv "$TMPDIR/nu" "$LOCAL_BIN/nu"
    chmod +x "$LOCAL_BIN/nu"
fi

# =============================================================================
# Step 3: Install chezmoi and apply dotfiles
# =============================================================================
step "3/5" "Installing chezmoi v$CHEZMOI_VERSION..."

if [[ -x "$LOCAL_BIN/chezmoi" ]] && "$LOCAL_BIN/chezmoi" --version 2>/dev/null | grep -q "$CHEZMOI_VERSION"; then
    skip
    echo "      Applying dotfiles..."
    "$LOCAL_BIN/chezmoi" apply
else
    sh -c "$(curl -fsSL get.chezmoi.io)" -- -b "$LOCAL_BIN" init --apply mkramers/dotfiles
fi

# =============================================================================
# Step 4: Install aqua
# =============================================================================
step "4/5" "Installing aqua $AQUA_VERSION..."

if [[ -x "$AQUA_BIN/aqua" ]]; then
    skip
else
    curl -fsSL "https://raw.githubusercontent.com/aquaproj/aqua-installer/$AQUA_VERSION/aqua-installer" | bash -s -- -i "$AQUA_BIN"
fi

# =============================================================================
# Step 5: Post-install setup
# =============================================================================
step "5/5" "Running post-install setup..."

# Add aqua to PATH for this session
export PATH="$AQUA_BIN:$LOCAL_BIN:$PATH"
export AQUA_POLICY_CONFIG="$HOME/.aqua/aqua-policy.yaml"

echo "      - Installing aqua packages..."
aqua i -l

echo "      - Installing yazi plugins..."
if command -v ya &>/dev/null; then
    ya pack -i
fi

echo "      - Setting up carapace completions..."
if command -v carapace &>/dev/null; then
    mkdir -p ~/.cache/carapace
    carapace _carapace nushell > ~/.cache/carapace/init.nu
fi

# =============================================================================
# Done
# =============================================================================
echo ""
echo -e "${GREEN}✓ Bootstrap complete!${NC}"
echo ""

read -p "Launch nushell now? [Y/n] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    exec "$LOCAL_BIN/nu"
fi
