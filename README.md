# Better Terminal Usage

<p align="center">
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage">
    <img src="docs/assets/terminal-screenshot.png" alt="Better Terminal Usage screenshot" width="100%">
  </a>
</p>

<p align="center">
  <strong>Opinionated Linux terminal environment bootstrapping: WezTerm + Fish + Starship with a layered developer tool stack.</strong>
</p>

<p align="center">
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-architecture">Architecture</a> •
  <a href="#-screenshots">Screenshots</a> •
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/wiki">Wiki</a>
</p>

<p align="center">
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/stargazers">
    <img src="https://img.shields.io/github/stars/rldyourmnd/rld-better-terminal-ai-usage?style=for-the-badge&logo=github" alt="GitHub stars">
  </a>
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/network/members">
    <img src="https://img.shields.io/github/forks/rldyourmnd/rld-better-terminal-ai-usage?style=for-the-badge&logo=github&color=blue" alt="GitHub forks">
  </a>
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/issues">
    <img src="https://img.shields.io/github/issues/rldyourmnd/rld-better-terminal-ai-usage?style=for-the-badge&logo=github" alt="GitHub issues">
  </a>
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/rldyourmnd/rld-better-terminal-ai-usage?style=for-the-badge&color=green" alt="License">
  </a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-Linux-orange?style=flat-square&logo=linux" alt="Platform">
  <img src="https://img.shields.io/badge/shell-Fish-9C27B0?style=flat-square&logo=fish-shell" alt="Shell">
  <img src="https://img.shields.io/badge/terminal-WezTerm-00D8FF?style=flat-square" alt="Terminal">
  <img src="https://img.shields.io/badge/prompt-Starship-DD0B78?style=flat-square" alt="Prompt">
</p>

---

## ✅ What this repository is

`rld-better-terminal-ai-usage` is a collection of scripts and configuration files to quickly set up a development terminal environment on Ubuntu/Debian Linux.

- Base terminal stack: WezTerm + Fish + Starship.
- Layered installation flow with independent scripts per layer.
- Optional AI CLI support (Claude, Gemini, Codex) via Layer 5.
- `install.sh` works as an orchestrator for all installation layers.

The repository is designed to be user-agnostic in scripts and runtime configs (no hardcoded `/home/<user>` in install/config logic).

## 🚀 Quick Start

```bash
git clone https://github.com/rldyourmnd/rld-better-terminal-ai-usage.git
cd rld-better-terminal-ai-usage
./scripts/install.sh
```

After setup:

```bash
exec fish
```

If Layer 5 is installed, authenticate AI CLI tools:

```bash
claude      # browser auth
gemini      # Login with Google
codex       # set OPENAI_API_KEY in environment
```

## 🧩 Installation

### Requirements

- Ubuntu/Debian (apt-based).
- `curl` and `git` (required by `install.sh`).
- `sudo` access for system packages.
- Internet access.

### Full install

```bash
./scripts/install.sh
```

`install.sh` executes:

- `scripts/install-layer-1.sh`
- `scripts/install-layer-2.sh`
- `scripts/install-layer-3.sh`
- `scripts/install-layer-4.sh`
- `scripts/install-layer-5.sh`
- `scripts/install-foundation.sh`

### Layer-by-layer install

```bash
./scripts/install-layer-1.sh
./scripts/install-layer-2.sh
./scripts/install-layer-3.sh
./scripts/install-layer-4.sh
./scripts/install-layer-5.sh
./scripts/install-foundation.sh
```

### Installed content by layer

| Layer | Script | Includes |
|---|---|---|
| Foundation | `install-foundation.sh` | WezTerm, Fish, Starship, Nerd Fonts, and config files |
| Layer 1 | `install-layer-1.sh` | bat, fd (fdfind), rg, sd, jq, yq, eza |
| Layer 2 | `install-layer-2.sh` | fzf, zoxide, atuin, uv, bun, watchexec, glow, bottom, hyperfine |
| Layer 3 | `install-layer-3.sh` | gh CLI, lazygit, delta |
| Layer 4 | `install-layer-4.sh` | grepai, ast-grep, probe, semgrep, ctags, tokei |
| Layer 5 | `install-layer-5.sh` | claude CLI, gemini CLI, codex CLI |

## 🏗️ Architecture

```text
Foundation: WezTerm + Fish + Starship
↓
Layer 1: File Operations (bat, fd, rg, sd, jq, yq, eza)
↓
Layer 2: Productivity (fzf, zoxide, atuin, uv, bun, watchexec, glow, bottom, hyperfine)
↓
Layer 3: GitHub workflow (gh, lazygit, delta)
↓
Layer 4: Code Intelligence (grepai, ast-grep, probe, semgrep, ctags, tokei)
↓
Layer 5: AI orchestration (claude, gemini, codex)
```

## 🖼️ Screenshots

<p align="center">
  <img src="docs/assets/terminal-screenshot.png" alt="Terminal screenshot" width="100%">
</p>

## 📁 Project structure

```text
better-terminal-usage/
├── scripts/
│   ├── install.sh
│   ├── install-foundation.sh
│   ├── install-layer-1.sh
│   ├── install-layer-2.sh
│   ├── install-layer-3.sh
│   ├── install-layer-4.sh
│   └── install-layer-5.sh
├── configs/
│   ├── fish/config.fish
│   ├── wezterm/wezterm.lua
│   └── starship/
├── docs/
│   └── layers/
├── context/
└── CHANGELOG.md
```

## 🛠 Troubleshooting

- If a layer fails, re-run that layer script after fixing the issue.

```bash
command -v bat rg fzf gh lazygit delta claude gemini codex
```

- If `sudo` is not available or apt access is restricted, Layer 3/4/5 scripts provide fallback instructions in their output.

## 🤝 Contributing

If you want to contribute:

- open an issue: <https://github.com/rldyourmnd/rld-better-terminal-ai-usage/issues>
- propose ideas in discussions: <https://github.com/rldyourmnd/rld-better-terminal-ai-usage/discussions>
- submit PRs with focused, verifiable changes.

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE).

## 🙌 Acknowledgements

- WezTerm, Fish, Starship teams and maintainers.
- All CLI tools used in this setup and their maintainers.
- Community documentation and project assets.

<p align="center">
  <strong>An open-source, user-agnostic terminal setup for developers using AI in daily workflows.</strong>
</p>
