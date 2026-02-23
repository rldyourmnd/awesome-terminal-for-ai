# Linux (Debian/Ubuntu)

This is the production implementation for Linux hosts.

## Scope

- Distributions: Debian/Ubuntu (APT-based)
- Shell: Fish
- Terminal: WezTerm
- Prompt: Starship
- Layers: Foundation + Layer 1..5
- Install style: non-interactive (`apt-get` + `DEBIAN_FRONTEND=noninteractive`)
- Reproducibility: Cargo-based tools installed with `cargo install --locked`

## Entrypoints

- Full install: `./scripts/install.sh`
- Flow dry-run: `./scripts/install.sh --dry-run`
- Health check: `./scripts/health-check.sh --summary`

## Layer Scripts

- `scripts/install-foundation.sh`
- `scripts/install-layer-1.sh`
- `scripts/install-layer-2.sh`
- `scripts/install-layer-3.sh`
- `scripts/install-layer-4.sh`
- `scripts/install-layer-5.sh`

## Canonical Linux Docs

- Foundation: `docs/foundation/foundation.md`
- Layers: `docs/layers/`
- Operations: `docs/operations/`
- Tool catalog (Linux): `docs/operations/terminal-tool-catalog.md`

## Notes

`./scripts/install.sh` now auto-detects OS. On Linux it runs the existing Linux pipeline.

## Operational Guarantees

- Official shell installers are downloaded to a temporary file and executed locally (no direct `curl | sh` pattern).
- Binary tarball installs for tools such as `lazygit`, `glow`, and `grepai` attempt checksum validation when release checksums are published.
- `health-check.sh` validates real `ast-grep` resolution (avoids false-positive system `sg` binary).

## Optional Integrity Pinning

For `yq` in Layer 1, you can pin checksum explicitly:

```bash
export YQ_SHA256="<sha256-from-official-release>"
./scripts/install-layer-1.sh
```

## Recommended Linux Verification Flow

```bash
bash -n scripts/*.sh scripts/macos/*.sh
./scripts/health-check.sh --summary
./scripts/health-check.sh --strict
```
