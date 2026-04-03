#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles Bootstrap Script
# Usage: curl -fsSL https://raw.githubusercontent.com/mkramers/dotfiles/main/bootstrap.sh | bash
# =============================================================================

# Resolve latest release versions from GitHub
resolve_latest() {
    curl -fsSL -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest" | grep -o '[^/]*$'
}

CHEZMOI_VERSION=$(resolve_latest "twpayne/chezmoi" | sed 's/^v//')

# Paths
LOCAL_BIN="$HOME/.local/bin"

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
step "1/4" "Creating directories..."
mkdir -p "$LOCAL_BIN"

# =============================================================================
# Step 2: Install chezmoi and apply dotfiles
# =============================================================================
step "2/4" "Installing chezmoi v$CHEZMOI_VERSION..."

if [[ -x "$LOCAL_BIN/chezmoi" ]] && "$LOCAL_BIN/chezmoi" --version 2>/dev/null | grep -q "v${CHEZMOI_VERSION}"; then
    skip
    echo "      Applying dotfiles..."
    "$LOCAL_BIN/chezmoi" apply
else
    sh -c "$(curl -fsSL get.chezmoi.io)" -- -b "$LOCAL_BIN" init --apply mkramers/dotfiles
fi

# =============================================================================
# Step 3: Install mise
# =============================================================================
step "3/4" "Installing mise..."

if [[ -x "$LOCAL_BIN/mise" ]]; then
    skip
else
    curl -fsSL https://mise.run | sh
fi

# =============================================================================
# Step 4: Post-install setup
# =============================================================================
step "4/4" "Running post-install setup..."

# Add mise to PATH for this session
export PATH="$LOCAL_BIN:$PATH"

echo "      - Installing mise packages..."
"$LOCAL_BIN/mise" install --yes 2>/dev/null || "$LOCAL_BIN/mise" install

echo "      - Installing yazi plugins..."
if command -v ya &>/dev/null; then
    ya pack -i &>/dev/null
fi

# =============================================================================
# Done
# =============================================================================
echo ""
echo -e "${GREEN}✓ Bootstrap complete!${NC}"
