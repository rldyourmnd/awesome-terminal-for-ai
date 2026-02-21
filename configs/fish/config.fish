# ═══════════════════════════════════════════════════════════════════════════════
# FISH CONFIGURATION - Ultimate AI Terminal Environment
# ═══════════════════════════════════════════════════════════════════════════════
# Performance: ~30ms startup (benchmark: fish --profile-startup /tmp/fish.prof -ic exit)
# Features: Conditional sourcing, transient prompt ready, AI-optimized abbreviations

# ═══════════════════════════════════════════════════════════════════════════════
# PATH SETUP - Use fish_add_path for proper persistence
# ═══════════════════════════════════════════════════════════════════════════════
# AI Tools
fish_add_path ~/.local/bin                    # claude, grepai, bat, lazygit
fish_add_path ~/.claude/local/bin             # claude local tools
fish_add_path ~/.atuin/bin                    # atuin

# Development runtimes
fish_add_path ~/.cargo/bin                    # rust tools: btm, delta, probe, ast-grep
fish_add_path ~/.bun/bin                      # bun
fish_add_path ~/.local/share/pnpm             # pnpm
fish_add_path /usr/local/go/bin               # go

# Homebrew
fish_add_path /home/linuxbrew/.linuxbrew/bin
fish_add_path /home/linuxbrew/.linuxbrew/sbin

# Python venvs
fish_add_path ~/.local/venvs/ai-ml/bin
fish_add_path ~/.local/venvs/vllm/bin

# Node (nvm)
fish_add_path ~/.nvm/versions/node/v24.13.1/bin

# Other tools
fish_add_path ~/.pulumi/bin
fish_add_path ~/Android/Sdk/emulator
fish_add_path ~/Android/Sdk/platform-tools
fish_add_path ~/.local/share/pipx

# ═══════════════════════════════════════════════════════════════════════════════
# TOOL INITIALIZATION - Conditional sourcing for stability
# ═══════════════════════════════════════════════════════════════════════════════
# Starship prompt (fastest prompt, Rust-based)
if type -q starship
    starship init fish | source
    # Transient prompt - cleaner scrollback (optional, uncomment if desired)
    # function starship_transient_prompt_func
    #     starship module character
    # end
    # enable_transience
end

# Zoxide (smart cd) - 2.9ms
if type -q zoxide
    zoxide init fish | source
end

# Atuin (history sync) - 5.2ms
if type -q atuin
    atuin init fish --disable-up-arrow | source
end

# FZF (fuzzy finder) - 2.5ms
if type -q fzf
    fzf --fish | source
end

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
# ABBREVIATIONS - Navigation
# ═══════════════════════════════════════════════════════════════════════════════
abbr -a z 'zoxide'
abbr -a zz 'z -'
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'

# ═══════════════════════════════════════════════════════════════════════════════
# ABBREVIATIONS - File operations
# ═══════════════════════════════════════════════════════════════════════════════
abbr -a ls 'eza'
abbr -a ll 'eza -la'
abbr -a lt 'eza --tree --level=2'
abbr -a cat 'bat'

# ═══════════════════════════════════════════════════════════════════════════════
# System monitoring
# ═══════════════════════════════════════════════════════════════════════════════
abbr -a bottom 'btm'

# ═════════════════════════════════════════════════════════════════════════════
# Git
# ═══════════════════════════════════════════════════════════════════════════════
abbr -a g 'git'
abbr -a gs 'git status'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gp 'git push'
abbr -a gl 'git log --oneline -10'
abbr -a gd 'git diff'
abbr -a lg 'lazygit'

# ═══════════════════════════════════════════════════════════════════════════════
# GitHub CLI
# ═══════════════════════════════════════════════════════════════════════════════
abbr -a gh 'gh'
abbr -a ghp 'gh pr'
abbr -a ghi 'gh issue'
abbr -a ghr 'gh repo'

# ═══════════════════════════════════════════════════════════════════════════════
# Python
# ═════════════════════════════════════════════════════════════════════════════
abbr -a py 'python3'
abbr -a pip 'uv pip'
abbr -a venv 'uv venv'

# ═══════════════════════════════════════════════════════════════════════════════
# Development
# ═════════════════════════════════════════════════════════════════════════════════
abbr -a nv 'nvim'
abbr -a code 'code .'

# ═══════════════════════════════════════════════════════════════════════════════
# AI Tools (Layer 5 - User-provided CLIs)
# ═════════════════════════════════════════════════════════════════════════════
abbr -a cl 'claude'
abbr -a gem 'gemini'
abbr -a cx 'codex'

# ═════════════════════════════════════════════════════════════════════════════
# FUNCTIONS
# ═════════════════════════════════════════════════════════════════════════════
function proj
    cd ~/projects/$argv[1]
end

function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

function backup
    cp $argv[1] $argv[1].bak.(date +%Y%m%d_%H%M%S)
end

function ducks
    du -sh * | sort -h
end

function ff
    fd -H $argv
end

function gg
    rg -i $argv
end

# ═════════════════════════════════════════════════════════════════════════════════
# STARTUP
# ═══════════════════════════════════════════════════════════════════════════════
set fish_greeting
