# .zshrc — interactive shells only. Architecture (2026-07 verdicts):
# agent-neutralization gate first, cached compinit, antidote static plugins,
# deferred tool inits, syntax highlighting last. Target: <50 ms to prompt.

# ── 1. Agent gate ────────────────────────────────────────────────────────────
# Harness markers: Claude Code sets CLAUDECODE; Codex sets CODEX_THREAD_ID /
# CODEX_SANDBOX; Cursor/Gemini legacy markers kept for safety. agy and mimo
# expose no stable marker — the interactive check catches them and any future
# harness. Agents get plain pipes: no pagers, no prompt, no history hooks,
# no frecency pollution.
_is_agent() {
  [[ -n $CLAUDECODE || -n $CODEX_THREAD_ID || -n $CODEX_SANDBOX \
     || -n $CURSOR_AGENT || -n $GEMINI_CLI ]] || [[ ! -o interactive ]]
}
if _is_agent; then
  export PAGER=cat GIT_PAGER=cat GH_PAGER=cat DELTA_PAGER=cat
  export LESS='-FRX' SYSTEMD_PAGER='' GIT_EDITOR=true
  return
fi

# ── 2. History (atuin owns interactive history; these are the fallbacks) ────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_VERIFY

# ── 3. Completion: full compinit at most once per 24h, else cached ──────────
autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qNmh-24) ]]; then
  compinit -C
else
  compinit
fi
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' menu no            # fzf-tab replaces the menu

# ── 4. Plugins via antidote (static file, see .zsh_plugins.txt) ─────────────
if [[ -r /opt/homebrew/opt/antidote/share/antidote/antidote.zsh ]]; then
  source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
  antidote load "${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
fi

# ── 5. Tool inits (zsh-defer, loaded via plugins, keeps prompt instant) ─────
(( $+functions[zsh-defer] )) || zsh-defer() { "$@" }   # fallback: run inline
zsh-defer eval "$(zoxide init zsh)"
zsh-defer eval "$(atuin init zsh --disable-up-arrow)"
command -v carapace >/dev/null && zsh-defer eval "$(carapace _carapace zsh)"

# ── 6. Prompt ────────────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ── 7. Aliases & abbreviations (zsh-abbr gives fish-style expansion) ────────
# Placement contract: this section only ever runs AFTER the section-1 agent
# gate has returned for non-interactive/marker-bearing shells, and zsh never
# reads .zshrc for non-interactive shells at all (zsh manual, Startup Files).
# Agents get the tools on PATH under their own names — nothing below exists
# for them. Shadowing policy (2026-07 verdicts):
#   alias = view-layer, argument-compatible supersets only (ls, cat, tree).
#   abbr  = replacements that expand VISIBLY before execution — flags meet
#           the new tool in plain sight; the expansion can be edited/undone.
#   never = grep, sed, awk, find, jq. rg "never was, isn't and never will be
#           POSIX compatible" (rg FAQ) and silently skips ignored/hidden
#           files; sd's positional CLI can't host sed one-liners. POSIX names
#           stay real; rg / sd / fd live under their own names.
alias ls='eza --group-directories-first'
alias ll='eza -la --git --group-directories-first'
alias tree='eza --tree'
alias cat='bat'
alias lg='lazygit'
# Harness launchers cl / cx / oc are real executables in ~/.local/bin
# (installed by rldyour-ai-cli-tools) — not aliases, so agents can exec them.
if command -v abbr >/dev/null; then
  abbr -S -qq gs='git status'      2>/dev/null
  abbr -S -qq gd='git diff'        2>/dev/null
  abbr -S -qq dft='git dft'        2>/dev/null   # difftastic difftool alias
  abbr -S -qq jql='jaq'            2>/dev/null   # fast jq sidecar, own name
  # 2026-07 modern-unix wave — human shells only, visible expansion
  abbr -S -qq du='dust'            2>/dev/null   # report-style disk usage
  abbr -S -qq dui='dua i'          2>/dev/null   # interactive delete walk
  abbr -S -qq df='duf'             2>/dev/null   # mount health table
  abbr -S -qq ps='procs'           2>/dev/null   # scripts still get real ps
  abbr -S -qq top='btop'           2>/dev/null
  abbr -S -qq htop='btop'          2>/dev/null
  abbr -S -qq dig='doggo'          2>/dev/null   # dog is dead; dig stays for scripts
  abbr -S -qq ping='gping'         2>/dev/null   # `command ping` for raw ICMP flags
  abbr -S -qq xxd='hexyl'          2>/dev/null   # viewing only; xxd -r has no peer
  abbr -S -qq watch='viddy'        2>/dev/null   # macOS ships no watch(1) anyway
fi

# ── 8. fzf keybindings (Ctrl-R handled by atuin; keep Ctrl-T / Alt-C) ───────
if [[ -r /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
