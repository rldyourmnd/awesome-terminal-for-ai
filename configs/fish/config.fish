# ═══════════════════════════════════════════════════════════════════════════════
# FISH CONFIGURATION - Ultimate AI Terminal Environment
# ═══════════════════════════════════════════════════════════════════════════════
# Performance: ~30ms startup (vs 915ms zsh before)
# Features: Autosuggestions, web-based config, modern scripting

# ═══════════════════════════════════════════════════════════════════════════════
# STARSHIP PROMPT - Fast, minimal (<5ms)
# ═══════════════════════════════════════════════════════════════════════════════
starship init fish | source

# ═══════════════════════════════════════════════════════════════════════════════
# ZOXIDE - Smart cd with frecency
# ═══════════════════════════════════════════════════════════════════════════════
zoxide init fish | source

# ═══════════════════════════════════════════════════════════════════════════════
# ATUIN - SQLite history with sync
# ═══════════════════════════════════════════════════════════════════════════════
atuin init fish --disable-up-arrow | source

# ═══════════════════════════════════════════════════════════════════════════════
# FZF - Fuzzy finder integration
# ═══════════════════════════════════════════════════════════════════════════════
fzf --fish | source

# ═══════════════════════════════════════════════════════════════════════════════
# ENVIRONMENT VARIABLES
# ═══════════════════════════════════════════════════════════════════════════════
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER bat

# FZF configuration
set -gx FZF_CTRL_T_OPTS "--walker-skip .git,node_modules,target --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
set -gx FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --level=1 {}'"

# ═══════════════════════════════════════════════════════════════════════════════
# ABBREVIATIONS - Fast command shortcuts
# ═══════════════════════════════════════════════════════════════════════════════
# Navigation
abbr -a z 'zoxide'
abbr -a zz 'z -'                    # Previous directory
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'

# File operations
abbr -a ls 'eza'
abbr -a ll 'eza -la'
abbr -a lt 'eza --tree --level=2'
abbr -a cat 'bat'

# Git
abbr -a g 'git'
abbr -a gs 'git status'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gp 'git push'
abbr -a gl 'git log --oneline -10'
abbr -a gd 'git diff'
abbr -a lg 'lazygit'

# GitHub CLI
abbr -a gh 'gh'
abbr -a ghp 'gh pr'
abbr -a ghi 'gh issue'
abbr -a ghr 'gh repo'

# Python
abbr -a py 'python3'
abbr -a pip 'uv pip'
abbr -a venv 'uv venv'

# Development
abbr -a nv 'nvim'
abbr -a code 'code .'

# ═══════════════════════════════════════════════════════════════════════════════
# FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

# Quick project jump
function proj
    cd ~/projects/$argv[1]
end

# Create directory and enter it
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

# Quick backup
function backup
    cp $argv[1] $argv[1].bak.(date +%Y%m%d_%H%M%S)
end

# Show disk usage (human readable, sorted)
function ducks
    du -sh * | sort -h
end

# Find file by name
function ff
    fd -H $argv
end

# Find in files (ripgrep)
function gg
    rg -i $argv
end

# ═══════════════════════════════════════════════════════════════════════════════
# STARTUP
# ═══════════════════════════════════════════════════════════════════════════════
# Disable greeting
set fish_greeting
