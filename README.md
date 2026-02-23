# Better Terminal Usage

<p align="center">
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage">
    <img src="docs/assets/terminal-screenshot.png" alt="Terminal screenshot" width="100%">
  </a>
</p>

<p align="center">
  <strong>Cross-platform terminal environment for Linux, macOS, and Windows with OS-first structure, layered installers, and production-grade validation.</strong>
</p>

<p align="center">
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/actions/workflows/ci.yml">
    <img src="https://img.shields.io/github/actions/workflow/status/rldyourmnd/rld-better-terminal-ai-usage/ci.yml?branch=main&style=for-the-badge" alt="CI">
  </a>
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/releases/tag/v2.0.0">
    <img src="https://img.shields.io/badge/release-v2.0.0-2ea44f?style=for-the-badge" alt="Release 2.0.0">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/github/license/rldyourmnd/rld-better-terminal-ai-usage?style=for-the-badge" alt="License">
  </a>
</p>

## OS-First Navigation

| Platform | Status | Install | Dry-run | Health check | Docs |
| --- | --- | --- | --- | --- | --- |
| Linux (Debian/Ubuntu) | Production | `./scripts/install.sh` | `./scripts/install.sh --dry-run` | `./scripts/health-check.sh --summary` | [`docs/platforms/linux/README.md`](docs/platforms/linux/README.md) |
| macOS | Production | `./scripts/install.sh` or `./scripts/install-macos.sh` | `./scripts/macos/install.sh --dry-run` | `./scripts/health-check-macos.sh --summary` | [`docs/platforms/macos/README.md`](docs/platforms/macos/README.md) |
| Windows (PowerShell + WinGet) | Production | `.\scripts\install-windows.ps1` | `.\scripts\install-windows.ps1 -DryRun` | `.\scripts\health-check-windows.ps1 -Summary` | [`docs/platforms/windows/README.md`](docs/platforms/windows/README.md) |

## What You Get

- WezTerm + shell + Starship baseline.
- Deterministic 5-layer tooling model.
- OS-dispatched installers with platform-specific implementations.
- Built-in health checks and CI smoke coverage for Linux/macOS/Windows.

## Quick Start

### Linux

```bash
git clone https://github.com/rldyourmnd/rld-better-terminal-ai-usage.git
cd rld-better-terminal-ai-usage
./scripts/install.sh
```

### macOS

```bash
git clone https://github.com/rldyourmnd/rld-better-terminal-ai-usage.git
cd rld-better-terminal-ai-usage
./scripts/install.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/rldyourmnd/rld-better-terminal-ai-usage.git
cd rld-better-terminal-ai-usage
.\scripts\install-windows.ps1
```

## Structure (Clean OS Layout)

```text
scripts/
├── install.sh                     # OS dispatcher
├── health-check.sh                # OS dispatcher
├── linux/                         # Linux canonical implementation
├── macos/                         # macOS canonical implementation
├── windows/                       # Windows canonical implementation
├── install-macos.sh               # wrapper
├── install-windows.ps1            # wrapper
├── health-check-macos.sh          # wrapper
└── health-check-windows.ps1       # wrapper

docs/
├── platforms/
│   ├── linux/
│   │   ├── README.md
│   │   └── reference/             # Linux foundation + layers reference
│   ├── macos/README.md
│   └── windows/README.md
├── operations/
└── assets/

wiki/                              # wiki source (published via script)
```

## Layer Model

| Layer | Scope |
| --- | --- |
| Foundation | Terminal + shell + prompt baseline |
| Layer 1 | File operations (`bat`, `fd`, `rg`, `sd`, `jq`, `yq`, `eza`) |
| Layer 2 | Productivity (`fzf`, `zoxide`, `atuin`, `uv`, `bun`, `watchexec`, `glow`, `btm`, `hyperfine`) |
| Layer 3 | GitHub/Git (`gh`, `lazygit`, `delta`) |
| Layer 4 | Code intelligence (`grepai`, `ast-grep`, `probe`, `semgrep`, `ctags`, `tokei`) |
| Layer 5 | AI orchestration (`claude`, `gemini`, `codex`) |

## Validation and Quality Gates

- Local:

```bash
./scripts/install.sh --dry-run
./scripts/health-check.sh --strict --summary
```

- CI (`.github/workflows/ci.yml`):
  - shell lint + syntax checks,
  - markdown lint,
  - link check,
  - Linux/macOS/Windows flow smoke.

## Documentation and Wiki

- Platform docs: [`docs/platforms/`](docs/platforms/)
- Operations runbooks: [`docs/operations/`](docs/operations/)
- Wiki source: [`wiki/`](wiki/)
- Wiki publish: `./scripts/publish-wiki.sh`

## Compatibility Notes

Legacy Linux root-level scripts (`scripts/install-layer-*.sh`, `scripts/install-foundation.sh`) are kept as wrappers and forward to `scripts/linux/*` to preserve existing workflows.

## Contributing

- Read [`CONTRIBUTING.md`](CONTRIBUTING.md)
- Read [`SECURITY.md`](SECURITY.md)
- Open issues: <https://github.com/rldyourmnd/rld-better-terminal-ai-usage/issues>

## License

MIT — see [`LICENSE`](LICENSE).
