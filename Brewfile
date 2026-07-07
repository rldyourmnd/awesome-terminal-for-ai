# awesome-terminal-for-ai — curated zsh-first terminal set (verdicts of 2026-07-07).
# Install: brew bundle --file Brewfile
# The full workstation baseline (LSPs, linters, AI CLI pins) is owned by
# NDDev-it-com/rldyour-new-mac-or-ubuntu; this file covers the terminal layer.

tap "olets/tap"

# Shell stack
brew "antidote"
brew "zsh-completions"
brew "olets/tap/zsh-abbr"
brew "starship"
brew "atuin"
brew "fzf"
brew "zoxide"
brew "carapace"

# Files, search, viewing
brew "ripgrep"
brew "fd"
brew "eza"
brew "bat"
brew "yazi"
brew "ast-grep"
brew "scc"

# Git
brew "gh"
brew "lazygit"
brew "git-delta"
brew "difftastic" # `git dft` alias only — never global diff.external

# Structured data
brew "jq"
brew "jaq"
brew "jnv"
brew "yq"
brew "duckdb"

# Network, watch, bench, run
brew "xh"
brew "watchexec"
brew "hyperfine"
brew "just"

# Sessions (servers / fleets)
brew "tmux"

# Terminal emulator
cask "ghostty" # config: scrollback-limit ~100MB, shell-integration-features = ssh-env

# System introspection & network (2026-07 wave — human lane; POSIX names untouched)
brew "dust"      # du report      — bootandy/dust 1.2.4 (2026-01)
brew "dua-cli"   # du interactive — Byron/dua-cli 2.37.1 (2026-06), `dua i`
brew "duf"       # df table       — muesli/duf 0.9.1 (2025-09; slow cadence, stable domain)
brew "procs"     # ps             — dalance/procs 0.14.12 (2026-06)
brew "btop"      # top/htop       — aristocratos/btop 1.4.7 (2026-05, 33k★)
brew "doggo"     # dig            — mr-karan/doggo 1.2.0 (2026-06); dog: dead, formula deleted
brew "gping"     # ping graph     — orf/gping 1.20.4 (2026-06)
brew "hexyl"     # xxd viewing    — sharkdp/hexyl 0.17.0 (2026-02)
brew "sd"        # sed-adjacent, OWN NAME ONLY — chmln/sd 1.1.0 (2026-02); never aliased
brew "viddy"     # watch          — sachaos/viddy 1.3.1 (2026-06); watchexec = file-event lane
brew "tealdeer"  # tldr client (installs `tldr`); brew "tldr" C-client is deprecated+disabled

# Optional experiments (uncomment deliberately)
# brew "television"
# brew "broot"
# brew "asciinema"
# brew "cheat"        # personal cheatsheet notebook — revived (5.1.0, 2026-02)
# brew "choose-rust"  # cut/awk-lite — rejected as core: no release since 2025-08
# brew "bottom"       # btm — runner-up monitor if btop ever stalls
# cask "kitty"
