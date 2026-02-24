# AGENTS.md - Project Policy for rldyourterm (Codex Runtime)

## Scope
- Applies to the repository root: `/home/rldyourmnd/Desktop/projects/nddev_projects/awesome-terminal-for-ai`.
- Governs architecture, coding decisions, and tool behavior for ChatGPT/Codex in this project.

## 1) Strategic Architecture
- We use strict **VSA** (Vertical Slice + Strict Architecture) style with hard layer isolation.
- The system is implemented as independent feature slices in the top layers, each with explicit contracts to lower layers.
- Core layer is the only business-logic authority:
  - terminal state model,
  - grid buffer,
  - protocol/escape parser,
  - session state transitions.
- Lower layers provide platform and OS services for the core:
  - windowing,
  - PTY process control,
  - fonts/glyph rasterization support,
  - clipboard/input/audio/notifications,
  - file system and IPC integration.
- No upper layer may read/write directly to lower layer internals; all interaction happens through interface contracts.

## 2) Layer Model
- `foundation/` (platform adapters)
  - No terminal policy.
  - Owns all environment-specific integration.
- `core/` (independent terminal engine)
  - No references to OS/windowing/rendering-specific crates.
  - Pure domain rules and deterministic state transitions.
- `services/` (orchestration)
  - Coordinates interactions between core and adapters.
  - Owns command handling, session lifecycle, crash-safe restart policy.
- `ui/` (rendering/interaction shell)
  - Owns UI composition and event ingestion only.
- `features/` (isolated feature modules)
  - GPU/CPU renderer
  - themes/styles
  - config management
  - shell integrations (fish/starship)
  - diagnostics/profiling
- `apps/` and binaries consume only public features/services APIs.

## 3) Dependency Direction Rules
- Dependencies must always point inward (feature → service → core).
- Foundation can be used by services/UI only through declared traits.
- Core must never depend on:
  - concrete rendering engines,
  - concrete window systems,
  - concrete third-party app frameworks.
- Interfaces (traits/ports) are mandatory between slice boundaries.

## 4) Independence and Code Provenance
- No feature starts as imported upstream terminal source.
- No copy-paste from external terminals, including WezTerm code.
- New code should be authored in-project first.
- External crates are allowed for low-level primitives and protocols only when no internal equivalent exists and architecture contract is preserved.
- Any dependency requiring wrappers must be isolated behind an adapter trait and tested as a service boundary.

## 5) Build Topology
- Each slice is a separate Cargo crate.
- Crate graph is acyclic by design.
- Public API between slices is restricted to stable contracts in `api/` modules.
- Shared types belong only to `types/`/`api/` and are versioned intentionally.

## 6) Configuration Strategy
- No monolithic static config file as the main feature switchboard.
- Runtime behavior is controlled via:
  - structured in-app configuration model,
  - schema-controlled persistence,
  - typed runtime actions.
- Fish/Starship behavior is implemented as explicit feature slices (shell slice + prompt integration slice), not as ad-hoc scripts.

## 7) Stability and Performance Requirements
- GPU and CPU rendering modes are mandatory and independently selectable:
  - `--render-mode gpu`,
  - `--render-mode cpu`,
  - `--render-mode auto` (auto fallback).
- No mode may crash or drop sessions on unsupported hardware.
- Rendering failures must degrade gracefully to lower mode.
- Core loop must remain deterministic under backpressure.

## 8) Delivery Discipline
- For each meaningful architectural step:
  - produce one or more small commits;
  - keep commits focused and reversible;
  - push to GitHub before task completion.
- Commit messages should use imperative form and include scope (ex: `feat(core/parser): ...`).

## 9) Documentation
- Every layer boundary and feature slice must have a short ADR-like note in `planning/`.
- No external claim or design decision without explicit rationale in docs before implementation.
