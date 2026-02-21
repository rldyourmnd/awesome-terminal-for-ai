#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# LAYER 1: FILE OPERATIONS INSTALLATION
# ═══════════════════════════════════════════════════════════════════════════════
# Installs: bat, fd, rg, sd, jq, yq, eza
# Platform: Linux (Ubuntu/Debian)
# Run: ./install-layer-1.sh

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if command exists
command_exists() { command -v "$1" &>/dev/null; }

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  LAYER 1: FILE OPERATIONS"
echo "  bat, fd, rg, sd, jq, yq, eza"
echo "════════════════════════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# PREFLIGHT CHECKS
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Running preflight checks..."

# Check for cargo (needed for sd)
if ! command_exists cargo; then
    log_warn "cargo not found. Installing rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # Source cargo env for current session
    if [ -f "$HOME/.cargo/env" ]; then
        . "$HOME/.cargo/env"
    fi
fi

# Verify cargo is available after potential install
if ! command_exists cargo; then
    log_error "cargo still not available after rust installation"
    log_error "Please run: source \$HOME/.cargo/env && ./scripts/install-layer-1.sh"
    exit 1
fi

log_success "Preflight checks passed"

# ═══════════════════════════════════════════════════════════════════════════════
# APT PACKAGES: bat, fd-find, ripgrep, jq, eza
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing apt packages..."

PACKAGES_TO_INSTALL=""

# Check each package
if ! command_exists bat && ! command_exists batcat; then
    PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL bat"
fi

if ! command_exists fd; then
    PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL fd-find"
fi

if ! command_exists rg; then
    PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL ripgrep"
fi

if ! command_exists jq; then
    PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL jq"
fi

if ! command_exists eza; then
    PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL eza"
fi

if [ -n "$PACKAGES_TO_INSTALL" ]; then
    sudo apt update
    sudo apt install -y $PACKAGES_TO_INSTALL
    log_success "Apt packages installed"
else
    log_info "All apt packages already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# BAT SYMLINK (Ubuntu installs as batcat)
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Setting up bat symlink..."

if command_exists batcat && ! command_exists bat; then
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat
    log_success "bat symlink created (~/.local/bin/bat -> /usr/bin/batcat)"
elif command_exists bat; then
    log_info "bat command already available"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# FD SYMLINK (apt package is fd-find)
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Setting up fd symlink..."

if command_exists fdfind && ! command_exists fd; then
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/fdfind ~/.local/bin/fd
    log_success "fd symlink created (~/.local/bin/fd -> /usr/bin/fdfind)"
elif command_exists fd; then
    log_info "fd command already available"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# SD (sed replacement) - cargo
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing sd (sed replacement)..."

if ! command_exists sd; then
    cargo install sd
    log_success "sd installed"
else
    log_info "sd already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# YQ (YAML/JSON/XML processor) - binary download
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing yq..."

if ! command_exists yq; then
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod +x /usr/local/bin/yq
    log_success "yq installed"
else
    log_info "yq already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# ENSURE ~/.local/bin IN PATH
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Ensuring ~/.local/bin in PATH..."

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"
    log_success "Added ~/.local/bin to PATH"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# VERIFICATION
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
echo "════════════════════════════════════════════════════════════"
echo "  VERIFICATION"
echo "════════════════════════════════════════════════════════════"
echo ""

# Verify each tool
TOOLS="bat fd rg sd jq yq eza"
INSTALLED=0
MISSING=0

for tool in $TOOLS; do
    if command_exists "$tool"; then
        version=$($tool --version 2>/dev/null | head -1)
        echo "✅ $tool: $version"
        ((INSTALLED++))
    else
        echo "❌ $tool: NOT INSTALLED"
        ((MISSING++))
    fi
done

echo ""
echo "Installed: $INSTALLED/7"

# ═══════════════════════════════════════════════════════════════════════════════
# COMPLETE
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  LAYER 1 COMPLETE!                                         ${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next: Run Layer 2: ./scripts/install-layer-2.sh"
else
    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  LAYER 1 PARTIALLY COMPLETE                                ${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Missing tools: $MISSING"
    echo "Try running the script again or install manually."
fi
