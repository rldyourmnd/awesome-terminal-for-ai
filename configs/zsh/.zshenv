# .zshenv — sourced by EVERY zsh (interactive, login, and `zsh -c` agent
# shells). Keep it tiny, side-effect-free, and PATH-complete: Codex/OpenCode
# run `zsh -l -c` and never read .zshrc, so anything an agent needs lives here.

typeset -U path PATH

path=(
  "$HOME/.local/share/mise/shims"   # mise: shims for non-interactive shells
  "$HOME/.local/bin"                # uv tools, own launchers (cl/cx/oc)
  "$HOME/.bun/bin"
  "$HOME/.cargo/bin"
  /opt/homebrew/bin
  /opt/homebrew/sbin
  /usr/local/bin
  $path
)

export EDITOR="${EDITOR:-nano}"
export LANG="${LANG:-en_US.UTF-8}"
