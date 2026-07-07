# Contributing

This repository is an **evidence-based specification**: verdict tables
(`TOOLKIT.md`), a curated `Brewfile`, and reference zsh configs. Contributions
are judged on evidence quality and agent-fit, not tool popularity.

## Ground rules

1. **Evidence or it doesn't ship.** A tool verdict change must cite the
   current version with a date and a primary source (GitHub release/activity,
   registry page). Blog folklore alone is insufficient.
2. **Agent-fit is mandatory analysis.** State how the tool behaves on pipes:
   pager use, color on non-tty, exit codes, `--json`/plain output, startup
   latency. Tools that break non-interactive shells need a neutralization
   note in `TOOLKIT.md`.
3. **Philosophy boundary.** Local machines write and check code only — no
   docker/colima/local clusters/service-hosting proposals.
4. **zsh-first.** Shell-layer contributions target zsh; fish/bash ports are
   out of scope.
5. **No installers.** Installation belongs to
   `NDDev-it-com/rldyour-new-mac-or-ubuntu`; here we curate and configure.

## Workflow

- Branch from `main`, Conventional Commits, PR with the template filled.
- Keep `zsh -n` clean for `configs/zsh/*` and markdownlint clean repo-wide
  (`npx --yes markdownlint-cli2 "**/*.md"`).
- `TOOLKIT.md` and `Brewfile` change together when a verdict changes.
- History under `planning/` and `metrics/` is frozen — do not modernize it.

## Reporting problems

Open an issue with the tool name, the claim being challenged, and your
evidence links. Security reports go through `SECURITY.md`, never public
issues.
