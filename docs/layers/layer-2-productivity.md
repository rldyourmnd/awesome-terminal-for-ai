# Layer 2: Productivity

> Tools that dramatically speed up daily workflows

## Overview

Productivity tools for fast navigation, history management, and package management. This layer focuses on reducing friction in everyday terminal operations.

## Tools

| Tool | Score | Purpose |
|------|-------|---------|
| **fzf** | 85.4 | Fuzzy finder for files, history, commands |
| **zoxide** | 39.7 | Smart cd with frecency learning |
| **Atuin** | 68.5 | SQLite history with encrypted sync |
| **uv** | 91.4 | Python package manager (10-100x faster than pip) |
| **bun** | 85 | JavaScript runtime (3-10x faster than npm) |
| **watchexec** | - | Auto-run commands on file changes |
| **glow** | 76.1 | Markdown renderer for terminal |
| **bottom** | - | System monitor (htop replacement) |
| **hyperfine** | 81.3 | Command benchmarking tool |

## Installation

```bash
# fzf (85.4) - fuzzy finder
sudo apt install -y fzf
# Or for latest version:
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# zoxide - smart cd
cargo install zoxide

# Atuin (68.5) - history sync
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# uv (91.4) - Python package manager
curl -LsSf https://astral.sh/uv/install.sh | sh

# bun (85) - JavaScript runtime
curl -fsSL https://bun.sh/install | bash

# watchexec - file watcher
cargo install watchexec

# glow (76.1) - markdown renderer
sudo apt install -y glow

# bottom - system monitor
cargo install bottom
# Or: sudo apt install -y bottom

# hyperfine (81.3) - benchmarking
cargo install hyperfine
```

## Usage Examples

### fzf - Fuzzy Finder

```bash
# Find files (Ctrl+T)
# Type to search, Enter to select

# Search command history (Ctrl+R)
# Fuzzy search through all history

# Change directory (Alt+C)
# Fuzzy search directories

# Preview files
fzf --preview 'bat --style=numbers --color=always {}'

# With ripgrep
rg --files | fzf

# Custom command
find * -type f | fzf > selected
```

### zoxide - Smart cd

```bash
# Add directory to database
z /path/to/project

# Jump to frequently used directory
z proj          # Jumps to ~/projects if frequently visited

# Jump with query
z repo code     # Jumps to ~/repos/code-project

# Interactive selection
zi              # fzf-powered selection

# Previous directory
z -
```

### Atuin - History Sync

```bash
# Search history (Ctrl+R replaced)
# Type to search with context

# Sync history
atuin sync

# View history
atuin history list

# Search specific command
atuin search "git commit"

# Login for sync
atuin login -u USERNAME
```

### uv - Python Package Manager

```bash
# Install package
uv pip install package

# Install from requirements
uv pip install -r requirements.txt

# Create virtual environment
uv venv

# Run Python with package
uvx package script.py

# Install tool globally
uv tool install black
```

### bun - JavaScript Runtime

```bash
# Install package
bun add package

# Run script
bun run script.ts

# Start project
bun start

# Install dependencies
bun install

# Run file directly
bun file.ts
```

### watchexec - File Watcher

```bash
# Run on any change
watchexec command

# Watch specific extensions
watchexec -e py,rs command

# Watch specific directory
watchexec -w src command

# Clear screen before run
watchexec -c command

# With shell
watchexec --shell bash "echo 'changed'"
```

### glow - Markdown Renderer

```bash
# Render file
glow README.md

# Render from stdin
cat README.md | glow

# Browse current directory
glow

# Pagination
glow -p README.md
```

### bottom - System Monitor

```bash
# Start monitor
btm

# Basic mode
btm --basic

# No network
btm --hide_avg_cpu
```

### hyperfine - Benchmarking

```bash
# Benchmark command
hyperfine 'command1' 'command2'

# Multiple runs
hyperfine -r 10 'command'

# Export results
hyperfine --export-markdown results.md 'command'
```

## Shell Integration

### Fish

```fish
# fzf
fzf --fish | source

# zoxide
zoxide init fish | source

# Atuin
atuin init fish --disable-up-arrow | source
```

### Zsh

```zsh
# fzf
source <(fzf --zsh)

# zoxide
eval "$(zoxide init zsh)"

# Atuin
eval "$(atuin init zsh)"
```

## Performance Comparison

| Task | Classic | Modern | Speedup |
|------|---------|--------|---------|
| Install Python package | pip | uv | 10-100x |
| Install JS package | npm | bun | 3-10x |
| Directory navigation | cd | zoxide | 5-10x |
| History search | Ctrl+R | Atuin | Better UX |
