#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# LAYER 4: CODE INTELLIGENCE INSTALLATION
# ═══════════════════════════════════════════════════════════════════════════════
# Installs: grepai, ast-grep, probe, semgrep, ctags, tokei
# Platform: Linux (Ubuntu/Debian)
# Run: ./scripts/install-layer-4.sh
#
# Verified February 2026:
# - grepai: 88.4 score - Go binary
# - ast-grep: 78.7 score - cargo
# - probe: cargo (probe-code)
# - semgrep: 70.4 score - pip
# - ctags: universal-ctags - apt
# - tokei: cargo

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

arch_for_binary() {
    case "$(uname -m)" in
        x86_64|amd64)
            echo x86_64
            ;;
        aarch64|arm64|armv8*|armv7*)
            echo arm64
            ;;
        *)
            echo x86_64
            ;;
    esac
}

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  LAYER 4: CODE INTELLIGENCE"
echo "  grepai, ast-grep, probe, semgrep, ctags, tokei"
echo "════════════════════════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# PREFLIGHT CHECKS
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Running preflight checks..."

# Check for cargo
if ! command_exists cargo; then
    log_warn "cargo not found. Installing rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    if [ -f "$HOME/.cargo/env" ]; then
        . "$HOME/.cargo/env"
    fi
fi

# Check for pip
if ! command_exists pip && ! command_exists pip3; then
    log_warn "pip not found. Installing python3-pip..."
    if sudo -n true 2>/dev/null; then
        sudo apt install -y python3-pip
    else
        log_error "pip requires sudo. Run: sudo apt install -y python3-pip"
    fi
fi

log_success "Preflight checks passed"

# ═══════════════════════════════════════════════════════════════════════════════
# CTAGS - Code indexing (apt)
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing universal-ctags..."

if ! command_exists ctags; then
    if sudo -n true 2>/dev/null; then
        sudo apt update
        sudo apt install -y universal-ctags
        log_success "ctags installed"
    else
        log_warn "ctags requires sudo. Run manually:"
        echo "  sudo apt install -y universal-ctags"
    fi
else
    log_info "ctags already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# TOKEI - Code statistics (cargo)
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing tokei..."

if ! command_exists tokei; then
    cargo install tokei
    log_success "tokei installed"
else
    log_info "tokei already installed: $(tokei --version 2>/dev/null | head -1)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# AST-GREP - Structural search and rewrite (cargo)
# Score: 78.7
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing ast-grep..."

# Check if sg is ast-grep or util-linux sg
IS_AST_GREP=false
if command_exists sg; then
    if sg --version 2>&1 | grep -q "ast-grep\|ast_grep"; then
        IS_AST_GREP=true
    fi
fi

if [ "$IS_AST_GREP" = false ]; then
    cargo install ast-grep
    log_success "ast-grep installed"
else
    log_info "ast-grep already installed: $(sg --version 2>/dev/null | head -1)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# PROBE - code extraction (cargo)
# /buger/probe
# Package: probe-code
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing probe..."

if ! command_exists probe; then
    cargo install probe-code
    log_success "probe installed"
else
    log_info "probe already installed: $(probe --version 2>/dev/null | head -1)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# SEMGREP - Security analysis (pip)
# Score: 70.4
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing semgrep..."

if ! command_exists semgrep; then
    # Use pip3 or pip with --break-system-packages for PEP 668
    PIP_CMD="pip3"
    if ! command_exists pip3; then
        PIP_CMD="pip"
    fi

    $PIP_CMD install --user --break-system-packages semgrep 2>/dev/null || $PIP_CMD install --user semgrep
    log_success "semgrep installed"
else
    log_info "semgrep already installed: $(semgrep --version 2>/dev/null | head -1)"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# GREPAI - Semantic code search (Go binary)
# Score: 88.4 (/yoanbernabeu/grepai)
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing grepai..."

if ! command_exists grepai && [ ! -f ~/.local/bin/grepai ]; then
    # Get latest version
    GREPAI_VERSION=$(curl -s https://api.github.com/repos/yoanbernabeu/grepai/releases/latest | grep -oP '"tag_name": "\K[^"]+' || echo "v0.33.0")

    log_info "Downloading grepai ${GREPAI_VERSION}..."

    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"

    GREPAI_ARCH="$(arch_for_binary)"
    GREPAI_URL="https://github.com/yoanbernabeu/grepai/releases/download/${GREPAI_VERSION}/grepai_${GREPAI_VERSION#v}_linux_${GREPAI_ARCH}.tar.gz"

    if curl -sSL -o grepai.tar.gz "$GREPAI_URL"; then
        tar xzf grepai.tar.gz
        mkdir -p ~/.local/bin
        mv grepai ~/.local/bin/grepai
        chmod +x ~/.local/bin/grepai
        log_success "grepai ${GREPAI_VERSION} installed to ~/.local/bin/"
    else
        log_error "Failed to download grepai"
    fi

    cd - > /dev/null
    rm -rf "$TEMP_DIR"
else
    if [ -f ~/.local/bin/grepai ]; then
        log_info "grepai already installed: $(~/.local/bin/grepai version 2>/dev/null | head -1)"
    else
        log_info "grepai already installed: $(grepai version 2>/dev/null | head -1)"
    fi
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

# Verify ctags
if command_exists ctags; then
    echo "✅ ctags: $(ctags --version 2>/dev/null | head -1 || echo 'installed')"
else
    echo "❌ ctags: NOT INSTALLED (run: sudo apt install -y universal-ctags)"
fi

# Verify tokei
if command_exists tokei; then
    echo "✅ tokei: $(tokei --version 2>/dev/null | head -1)"
else
    echo "❌ tokei: NOT INSTALLED"
fi

# Verify ast-grep (check it's the right one)
if command_exists sg && sg --version 2>&1 | grep -q "ast-grep\|ast_grep\|0\."; then
    echo "✅ ast-grep: $(sg --version 2>/dev/null | head -1)"
elif [ -f ~/.cargo/bin/sg ]; then
    echo "✅ ast-grep: $(~/.cargo/bin/sg --version 2>/dev/null | head -1)"
else
    echo "⚠️  ast-grep: sg exists but may be util-linux (run: ~/.cargo/bin/sg --version)"
fi

# Verify probe
if command_exists probe; then
    echo "✅ probe: $(probe --version 2>/dev/null | head -1)"
else
    echo "❌ probe: NOT INSTALLED"
fi

# Verify semgrep
if command_exists semgrep; then
    echo "✅ semgrep: $(semgrep --version 2>/dev/null | head -1)"
else
    echo "❌ semgrep: NOT INSTALLED"
fi

# Verify grepai
if command_exists grepai; then
    echo "✅ grepai: $(grepai --version 2>/dev/null | head -1 || echo 'installed')"
else
    echo "❌ grepai: NOT INSTALLED"
fi

echo ""
echo "Verified Scores:"
echo "  grepai:   88.4 (/yoanbernabeu/grepai)"
echo "  ast-grep: 78.7 (/ast-grep/ast-grep.github.io)"
echo "  semgrep:  70.4 (/semgrep/semgrep-docs)"

# ═══════════════════════════════════════════════════════════════════════════════
# COMPLETE
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  LAYER 4 COMPLETE!                                         ${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Next steps:"
echo "1. Initialize grepai: grepai init"
echo "2. Try ast-grep: sg -p 'fn \$NAME(\$ARGS) { \$\$BODY }' -l rust"
echo "3. Run security scan: semgrep --config auto ."
echo "4. Run Layer 5: ./scripts/install-layer-5.sh"
echo ""
