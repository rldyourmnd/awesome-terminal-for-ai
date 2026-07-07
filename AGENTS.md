# awesome-terminal-for-ai — agent rules

This repository is the owner's **zsh-first terminal toolkit specification** for
AI-agent workflows: evidence-based tool verdicts (`TOOLKIT.md`), the curated
install set (`Brewfile`), and reference shell configs (`configs/`). It contains
**no installers** — installation is owned by the estate workstation module
[`NDDev-it-com/rldyour-new-mac-or-ubuntu`](https://github.com/NDDev-it-com/rldyour-new-mac-or-ubuntu),
and harness configuration by
[`NDDev-it-com/rldyour-ai-cli-tools`](https://github.com/NDDev-it-com/rldyour-ai-cli-tools).

## The contract (hard rules)

1. **zsh-first.** The shell baseline is zsh on macOS (Apple Silicon primary)
   and Ubuntu servers. Fish support was retired in 3.0.0 — do not reintroduce
   fish configs or `chsh` steps.
2. **Local machines write and check code only.** No docker/colima/k8s-local,
   no service hosting, no database installs — services run on remote servers.
   Anything violating this is rejected regardless of how popular the tool is.
3. **Evidence or it doesn't ship.** Every verdict in `TOOLKIT.md` carries a
   version current as of its sweep date and a primary source. Refresh verdicts
   with fresh registry/GitHub evidence; never from memory or blog folklore.
4. **Agent-fit is a first-class criterion.** Tools must behave on pipes
   (no pagers, clean exit codes, ideally `--json`); the neutralization gate in
   `configs/zsh/.zshrc` is the canonical pattern and must stay the first thing
   an interactive zsh evaluates.
5. **Five harnesses are the audience:** Claude Code (`cl`), Codex (`cx`),
   OpenCode (`oc`), Antigravity (`agy`), MiMoCode (`mimo`). Launchers are real
   executables from the control plane — never shell aliases here.
6. **No duplication of the module.** LSPs, linters, type checkers, AI-CLI pins
   live in `rldyour-new-mac-or-ubuntu`; this repo curates the terminal layer
   (shell stack, prompt, history, finders, TUIs, structured-data CLIs).
7. **English everywhere;** Conventional Commits; sole-authored commits without
   `Co-Authored-By` trailers; never rewrite pushed history.

## Layout

| Path | Meaning |
|---|---|
| `TOOLKIT.md` | Verdict tables + cut list + agent-fit rules (the spec core) |
| `Brewfile` | The curated terminal set, installable via `brew bundle` |
| `configs/zsh/` | `.zshenv` / `.zprofile` / `.zshrc` / `.zsh_plugins.txt` reference |
| `configs/starship/` | Prompt profiles (docker/k8s segments deliberately absent) |
| `rldyourterm/` | Parked GPU terminal engine, pinned at its last main (`550d78f`) |
| `planning/`, `metrics/` | Historical v1.0 engine design corpus — see `planning/HISTORICAL.md`; do not "modernize" |

## Working here

- Verdict refresh = edit `TOOLKIT.md` + `Brewfile` together, cite evidence in
  the commit body, bump `VERSION` (patch), tag after merge.
- Config changes must keep `zsh -n` clean and the agent gate semantics intact.
- The `rldyourterm` submodule advances only by explicit owner decision; its
  internal state (detached HEAD) is normal.
