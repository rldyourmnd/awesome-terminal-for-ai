# Changelog

All notable changes to this project are documented here.

The project follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.1.0] - 2026-07-07

### Added

- Classic-command replacement map (2026-07 wave) in TOOLKIT.md and the
  matching visible-expansion abbr block in `configs/zsh/.zshrc`: dust/dua,
  duf, procs, btop, doggo, gping, hexyl, viddy; `sd` and tealdeer under
  their own names. Policy codified: never shadow grep/sed/awk/find/jq.
- Brewfile: the introspection/network wave (11 formulas); tealdeer replaces
  the deprecated brew `tldr` C-client.

## [3.0.0] - 2026-07-07

The zsh-first rebirth. The repository's identity changes from "terminal
distribution with installers" to **evidence-based terminal toolkit spec for
AI-agent workflows**.

### Added

- `TOOLKIT.md` — per-category verdicts (winner / runner-up / version @
  2026-07-07) from a primary-source GitHub/registry sweep, cut list, and
  agent-fit ground rules.
- `Brewfile` — the curated terminal layer (antidote, starship, atuin, fzf,
  zoxide, yazi, lazygit, xh, jaq, jnv, DuckDB, ast-grep, scc, difftastic,
  tmux, Ghostty cask, and friends).
- `configs/zsh/` — reference `.zshenv` / `.zprofile` / `.zshrc` /
  `.zsh_plugins.txt` with the canonical **agent-neutralization gate**
  (pager/env hardening + early return for harness shells).
- `planning/HISTORICAL.md` — banner marking the v1.0 engine design corpus as
  preserved history.

### Changed

- **Shell contract: fish-first → zsh-first.** The owner's five harnesses
  (Claude Code, Codex, OpenCode, Antigravity, MiMoCode) run against zsh;
  Codex/OpenCode `zsh -l -c` semantics drive the env-in-`.zshenv`
  architecture.
- Installation is delegated to `NDDev-it-com/rldyour-new-mac-or-ubuntu`;
  harness configuration to `NDDev-it-com/rldyour-ai-cli-tools`.
- `configs/starship/starship.toml` no longer renders docker/kubernetes
  segments (local machines host no services by contract).
- AGENTS.md rewritten in English as the spec contract; CI reduced to
  spec-lint (zsh syntax + markdownlint); markdownlint re-enabled except
  line-length.
- `rldyourterm` submodule repaired: branch `main`, gitlink `550d78f` (the
  previously recorded commit and branch no longer existed after the engine's
  history rewrite).

### Removed

- All platform installers, health checks and release scripts (`scripts/`),
  the fish config, the obfuscated WezTerm-era `configs/rldyourterm/*.lua`,
  layer docs for dead distribution channels (`docs/platforms/`,
  `docs/operations/`, `wiki/`), and `release.yml`.

### Versioning note

Tags `v1.1.0`–`v2.0.4` were cut from the pre-rewrite fork history; their
release notes were removed during the February 2026 reset, and `VERSION` had
regressed to `1.0.0` beneath the already-published `v2.0.4`. Those tags remain
in the repository as history. **3.0.0 restarts a coherent line** for the
zsh-first spec era.

## [1.0.0] - 2026-02-24

### Added

- Full top-layer rebrand to `rldyourterm` with canonical wrappers and script naming.
- New local launch entrypoint: `scripts/rldyourterm`.
- New launch wrapper naming across docs and operations.

### Changed

- Removed legacy version-note release clutter from active documentation index.
- Updated release marker in top-level metadata and project badges.

### Fixed

- Repository-wide name drift in top-level setup instructions and docs.

---

[Unreleased]: https://github.com/rldyourmnd/awesome-terminal-for-ai/compare/3.1.0...HEAD
[3.1.0]: https://github.com/rldyourmnd/awesome-terminal-for-ai/releases/tag/3.1.0
[3.0.0]: https://github.com/rldyourmnd/awesome-terminal-for-ai/releases/tag/3.0.0
[1.0.0]: https://github.com/rldyourmnd/awesome-terminal-for-ai/releases/tag/v1.0.0
