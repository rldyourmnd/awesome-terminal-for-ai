# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-02-21

### Added
- **Foundation Layer**: WezTerm terminal with GPU acceleration, Fish shell, Starship prompt
- **Layer 1 - File Operations**: bat, fd, ripgrep, sd, jq, yq, eza
- **Layer 2 - Productivity**: fzf, zoxide, Atuin, uv, bun, watchexec, glow, bottom, hyperfine
- **Layer 3 - GitHub & Git**: gh CLI, lazygit, delta with Catppuccin theme
- **Layer 4 - Code Intelligence**: grepai, ast-grep, probe, semgrep, ctags, tokei
- Complete installation scripts for each layer
- Comprehensive documentation for all tools
- Fish shell configuration with abbreviations and functions
- Starship prompt configuration with minimal, fast theme
- WezTerm configuration with WebGPU/Vulkan support

### Performance
- Shell startup: 915ms → 30ms (30x faster)
- Terminal startup: 300-500ms → 50-80ms (6x faster)
- Input latency: ~50ms → <5ms (10x faster)

### Documentation
- Layer-specific documentation in `docs/layers/`
- Foundation documentation in `docs/foundation/`
- Research data in `context/`
- Contributing guidelines

## [Unreleased]

### Planned
- macOS support
- Nix/NixOS configuration
- Ansible playbook
- Docker container
- Video tutorials

---

[1.0.0]: https://github.com/rldyourmnd/better-terminal-usage/releases/tag/v1.0.0
