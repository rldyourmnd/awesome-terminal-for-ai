# Benchmark Scores (Research Snapshot)

> Historical research snapshot from February 2026.
> For current machine versions and runtime state, use `context/system-state.md`.

## Terminals

| Terminal | Score | Language | GPU | Notes |
|----------|-------|----------|-----|-------|
| **WezTerm** | **91.1** | Rust | WebGPU/Vulkan | WINNER - Built-in multiplexer |
| Wave | 86.2 | Electron | No | AI features, slower |
| Kitty | 80.5 | Python+C | OpenGL | Stable, good Wayland |
| Zellij | 79.4 | Rust | No | Multiplexer only |
| Rio | 69.6 | Rust | WGPU | New, promising |
| Tmux | 62.6 | C | No | Classic multiplexer |
| Alacritty | 37.4 | Rust | OpenGL | Minimal features |
| Warp | 72.1 / 6.5 | Rust | Yes | Proprietary, AI platform |

## Shells

| Shell | Score | POSIX | Startup |
|-------|-------|-------|---------|
| **Fish** | **94.5** | No | ~30ms |
| Xonsh | 86.0 | Yes | ~200ms |
| **Nushell** | **85.0** | No | ~50ms |
| Zsh (base) | 70.9 | Yes | ~20ms |
| PowerShell | 36.0 | No | ~300ms |

## ZSH Frameworks

| Framework | Score | Startup Impact |
|-----------|-------|----------------|
| Oh-My-Zsh | 87.7 | +200-500ms |
| **Zinit** | **87.3** | **-50-80% (Turbo)** |
| Prezto | 73.7 | +100-200ms |

## Prompts

| Prompt | Score | Startup | Cross-shell |
|--------|-------|---------|-------------|
| **Starship** | **80.8** | <5ms | Yes |
| Powerlevel10k | N/A | <5ms+Instant | No (zsh only) |

## File Operations (Layer 1)

| Tool | Score | Replaces | Version (Feb 2026) |
|------|-------|----------|-------------------|
| **yq** | **96.4** | YAML/JSON/XML processor | v4.52.4 |
| **bat** | **91.8** | cat | v0.26.1 |
| **sd** | **90.8** | sed | v1.0.0 |
| **fd** | **86.1** | find | v10.3.0 |
| **jq** | **85.7** | JSON processor | 1.8.1 |
| **ripgrep** | **81** | grep | 15.1.0 |
| **eza** | **85.0** | ls | v0.23.4 |

## Productivity (Layer 2)

| Tool | Score | Purpose | Version (Feb 2026) |
|------|-------|---------|-------------------|
| **uv** | **91.4** | Python package manager | 0.10.4 |
| **fzf** | **85.4** | Fuzzy finder | v0.68.0 |
| **zoxide** | **85.0** | Smart cd | v0.9.9 |
| **bun** | **85.0** | JavaScript runtime | v1.3.9 |
| **hyperfine** | **81.3** | Benchmarking | - |
| **glow** | **76.1** | Markdown renderer | v2.1.1 |
| **Atuin** | **68.5** | History sync | v18.12.1 |
| **watchexec** | **78.0** | File watcher | - |
| **bottom** | **75.0** | System monitor | 0.12.3 |

## GitHub & Git (Layer 3)

| Tool | Score | Purpose | Version (Feb 2026) |
|------|-------|---------|-------------------|
| **gh CLI** | **83.2** | GitHub in terminal | v2.87.2 |
| **lazygit** | **46** | Git TUI | v0.59.0 |
| **delta** | **82.0** | Git diff viewer | 0.18.2 |
| CodeQL | 73.9 | Code analysis | - |

## Code Intelligence (Layer 4)

| Tool | Score | Type | Version (Feb 2026) |
|------|-------|------|-------------------|
| **grepai** | **88.4** | Semantic search | pip install |
| **ast-grep** | **78.7** | AST structural | cargo install |
| semgrep | 70.4 | Security analysis | pip install |
| probe | 75.0 | Code extraction | cargo install |
| ctags | 70.0 | Code indexing | apt install |
| tokei | 72.0 | Code statistics | cargo install |

## AI/LLM Tools (Layer 5 - User-provided)

| Tool | Score | Purpose |
|------|-------|---------|
| **claude CLI** | **89.3** | Anthropic AI assistant |
| **gemini CLI** | **87.0** | Google AI assistant |
| **codex CLI** | **86.0** | OpenAI code generation |
| DocsGPT | 84.4 | Documentation Q&A |
| aider CE | 69.8 | AI pair programming |
| mods | 67.9 | LLM in pipelines |
| GPT Researcher | 73.2 | Research reports |
| shell-gpt | 60.7 | GPT assistant |

## Summary: Top 20 Tools by Score

| Rank | Tool | Score | Category | Version |
|------|------|-------|----------|---------|
| 1 | yq | 96.4 | File Ops | v4.52.4 |
| 2 | Fish | 94.5 | Shell | apt |
| 3 | bat | 91.8 | File Ops | v0.26.1 |
| 4 | uv | 91.4 | Productivity | 0.10.4 |
| 5 | WezTerm | 91.1 | Terminal | apt |
| 6 | sd | 90.8 | File Ops | v1.0.0 |
| 7 | claude CLI | 89.3 | AI | - |
| 8 | grepai | 88.4 | Code Intelligence | pip |
| 9 | Oh-My-Zsh | 87.7 | ZSH Framework | - |
| 10 | Zinit | 87.3 | ZSH Framework | - |
| 11 | fd | 86.1 | File Ops | v10.3.0 |
| 12 | bun | 85.0 | Productivity | v1.3.9 |
| 13 | Nushell | 85.0 | Shell | - |
| 14 | fzf | 85.4 | Productivity | v0.68.0 |
| 15 | jq | 85.7 | File Ops | 1.8.1 |
| 16 | Wave Terminal | 86.2 | Terminal | - |
| 17 | gh CLI | 83.2 | GitHub | v2.87.2 |
| 18 | Kitty | 80.5 | Terminal | - |
| 19 | Starship | 80.8 | Prompt | - |
| 20 | ripgrep | 81 | File Ops | 15.1.0 |

## User Environment Scores

### Current State
| Component | Status |
|-----------|--------|
| Terminal (xterm) | Not ranked (slow, CPU-only) |
| Shell (zsh) | 70.9 + 915ms startup (broken) |
| Prompt | Unknown |

### After Optimization
| Component | Tool | Score |
|-----------|------|-------|
| Terminal | WezTerm | 91.1 |
| Shell | Fish | 94.5 |
| Prompt | Starship | 80.8 |

### Improvement
- Terminal: **Not ranked → 91.1**
- Shell: **70.9 → 94.5** (30x faster startup)
- Overall: **Massive improvement across all layers**
