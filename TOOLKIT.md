# The Toolkit — verdicts as of 2026-07-07

Evidence-based picks for a zsh-first, AI-agent-heavy terminal. Every version and
date below comes from a primary-source sweep (authenticated GitHub API release
data, 2026-07-07) plus repo-grounded research; the full evidence trail lives in
the estate session archive. Install channel of record:
[`rldyour-new-mac-or-ubuntu`](https://github.com/NDDev-it-com/rldyour-new-mac-or-ubuntu)
plus this repo's [`Brewfile`](Brewfile).

## Core verdicts

| Category | Winner @ 2026-07 | Runner-up | Why it wins for agent workflows |
|---|---|---|---|
| Terminal emulator | **Ghostty 1.3.x** | Kitty 0.47.x | Fastest key-to-screen on Apple Silicon; 1.3 added scrollback search + a dedicated search thread; I/O benchmarked against 4 GB agent-log replays. Config: `scrollback-limit` ≈ 100 MB, `shell-integration-features = ssh-env` for servers. |
| zsh plugin manager | **antidote 2.1** | vanilla + zsh-defer | Compiles `.zsh_plugins.txt` into one static file — manifest-driven like the estate; top tier in load-time benchmarks. zinit rejected (bottom-tier load, complexity). |
| Autosuggestions | **zsh-autosuggestions** | — | zsh-autocomplete rejected outright: 4–5 s startup and macOS CPU issues per its own tracker. |
| Syntax highlight | **zsh-syntax-highlighting** | fast-syntax-highlighting | Maintenance wins: zsh-users pushed 2026-02; the F-Sy-H continuum fork stalled 2025-07. Load LAST. |
| Completions UX | **fzf-tab 1.3** + zsh-completions | carapace-bin 1.7 | fzf-everywhere completion menus; carapace if fish-grade argument completion is wanted. |
| Prompt | **starship 1.26** | powerlevel10k | p10k on declared life support since 2024. Starship: one Rust binary, same prompt on macOS+servers, TOML in-repo. |
| History | **atuin 18.16** | plain HISTFILE+fzf | Daemon stable; interactive-shells-only by design (agents never pollute history); self-hosts on sqlite — no Docker. |
| Fuzzy finder | **fzf 0.74** | television 0.15 | junegunn's cadence unmatched (0.74.0 released 2026-07-06); television is the credible experiment, not the default. |
| Smarter cd | **zoxide 0.10** | — | Unchallenged 2024→2026. Gate it away from agent shells (frecency pollution). |
| File manager TUI | **yazi 26.5** | broot 1.57 | Async I/O, Lua plugins, ecosystem default. Human-only tool. |
| Git TUI | **lazygit 0.63** | gitui 0.28 | 80k★ vs 22k★, weekly vs quarterly releases. |
| JSON core | **jq 1.8** (canonical) | jaq 3.1 as `jaq` | Model training corpora are saturated with jq — never alias it away. jaq for hot paths under its own name. |
| JSON interactive | **jnv 0.7** | fx | Purpose-built jq iteration; fx slowing since 2025-11. |
| YAML/TOML | **yq 4.53** | — | Edit-in-place across YAML/TOML/XML. dasel cut as redundant. |
| CSV/tabular | **DuckDB 1.5** | miller | Agents speak SQL natively: `duckdb -c "SELECT … FROM 'x.csv'"`. |
| HTTP client | **xh 0.26** + system curl | — | httpie dormant since 2024-11 with Python startup tax; xh is httpie-syntax in Rust with `--curl` for handing commands to agents. Agents themselves emit curl — keep it. |
| Code-aware search | **ast-grep 0.44** | — | Structural search/rewrite with `--json`; near-weekly releases; experimental MCP server. |
| LOC/complexity | **scc 3.7** | tokei 14 | Adds complexity/COCOMO + `--format json`, fresher release. |
| Diff (human) | **delta 0.19** | difftastic 0.69 | delta as `core.pager` is agent-safe (pagers never fire on pipes). difftastic ONLY as a `git dft` alias — its own README says output is not patch-applicable, JSON gated behind `DFT_UNSTABLE`; never set it as global `diff.external`. |
| Multiplexer | **tmux 3.7b (servers)** / none locally | zellij 0.44 | Agent ecosystem standardized on tmux (Terminal-Bench, claude-squad). Locally the harnesses background themselves — Ghostty tabs suffice. |
| Session record | **asciinema 3.2** (optional) | `script(1)` | Rust rewrite, live streaming, self-hostable — forensic capture of full-terminal agent behavior. |
| Repo→LLM packer | **repomix 1.16** | yek 0.25 | The default of its class (26.9k★, MCP server, `--compress`); yek as the raw-speed complement. |

## Purpose-built for terminal agents (2025–2026 wave)

- **repomix / yek** — context packing (above).
- **agentapi 0.12** — HTTP control plane over harness TUIs; adopt when
  orchestrating across machines.
- **claude-squad 1.0** — tmux + git-worktree fleets of Claude Code/Codex
  instances; the main reason tmux stays installed locally.
- **VibeTunnel** — browser/phone access to local agent terminals; adopt at 1.0
  (targeted end of July 2026).
- **serena** — LSP-backed semantic MCP; already deployed estate-wide.

## Cut list (held the crown yesterday, lost it)

| Cut | Replaced by | Reason |
|---|---|---|
| httpie | xh (+curl) | Dormant since 2024-11; interpreter startup tax. |
| dasel | jq + yq (+DuckDB) | Redundant surface; v3 rewrite lost model familiarity. |
| miller | DuckDB | SQL is the agent-native tabular interface. |
| powerlevel10k | starship | Life support since 2024-01. |
| zinit | antidote | Bottom-tier load time; complexity. |
| zsh-autocomplete | fzf-tab | 4–5 s startup, CPU hog (its own tracker). |
| fast-syntax-highlighting | zsh-syntax-highlighting | Fork stalled 2025-07. |
| WezTerm | Ghostty/Kitty | No stable release since 2024-02 (nightly-only). |
| Warp | Ghostty + own harnesses | Cloud-coupled agent backend; wrong for BYO-harness. |
| skim, gitui, fx, tokei, curlie | fzf, lazygit, jnv, scc, xh | Cadence/ecosystem gaps. |
| fish (here) | zsh | Owner contract is zsh-first — see `configs/zsh/`. |

## Classic-command replacement map (2026-07 wave)

Aliases live only in interactive zsh (section 7 of `configs/zsh/.zshrc`, after
the agent gate) — agents are structurally unaffected and get every tool on
PATH under its own name. Policy: `alias` only for view-layer supersets;
`abbr` (visible expansion) for replacements; **never** shadow grep/sed/awk/
find/jq — rg is deliberately non-POSIX and skips ignored files silently
(its own FAQ), and sd's positional CLI cannot host sed programs.

| Classic | Replacement | Form | Notes |
|---|---|---|---|
| `du` | **dust** 1.2 / **dua** 2.37 (`dua i`) | abbr | report lane / interactive delete walk |
| `df` | **duf** 0.9 | abbr | cadence slow (2025-09) but domain-stable |
| `ps` | **procs** 0.14 | abbr | real `ps` stays for scripts |
| `top`/`htop` | **btop** 1.4 (runner-up: bottom) | abbr | human TUI only |
| `dig` | **doggo** 1.2 | abbr | `dog` is dead — brew formula deleted |
| `ping` | **gping** 1.20 | abbr | `command ping` for raw ICMP flags |
| `xxd` | **hexyl** 0.17 | abbr | viewing only; `xxd -r` has no peer |
| `watch` | **viddy** 1.3 | abbr | macOS ships no watch(1); watchexec = file-event lane, unchanged |
| `sed`-adjacent | **sd** 1.1 | own name | NEVER aliased — semantics differ |
| tldr client | **tealdeer** 1.8 | own name (`tldr`) | brew `tldr` C-client deprecated+disabled upstream |
| `tree`/`cloc`/`cd`/`cat` | eza --tree / scc / zoxide / bat | settled | earlier verdicts |
| rejected | gdu, navi (stale >1y), dog (dead), choose (stale) | — | one niche, one tool |

semgrep (1.168, security/SAST lane — lives in the workstation module) and
ast-grep (structural lane) are confirmed complementary, not substitutes.

## Agent-fit ground rules

1. **Pagers are the #1 agent-breaker.** The neutralization block in
   [`configs/zsh/.zshrc`](configs/zsh/.zshrc) sets `PAGER=cat GIT_PAGER=cat
   GH_PAGER=cat LESS=-FRX GIT_EDITOR=true` and returns early for
   non-interactive or marker-bearing shells (`CLAUDECODE`, `CODEX_THREAD_ID`,
   `CODEX_SANDBOX`, `CURSOR_AGENT`, `GEMINI_CLI`).
2. **Env lives in `.zshenv`, interactivity in `.zshrc`.** `zsh -l -c` (Codex,
   OpenCode) never reads `.zshrc`; PATH must not depend on it.
3. **Codex hides secrets by default** — `shell_environment_policy` excludes
   `*KEY*`/`*SECRET*`/`*TOKEN*` from child env; configure exceptions in
   `config.toml`, don't fight it in shell.
4. **mise: shims for agents, `mise activate` for humans** — per mise's own
   docs, shims are the non-interactive path.
5. difftastic never as global `diff.external`; delta safe as pager (tty-only
   by construction).
