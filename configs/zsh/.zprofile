# .zprofile — login shells only (Terminal.app/Ghostty tabs, `zsh -l -c`).
# brew shellenv sets HOMEBREW_* and completes PATH/MANPATH/INFOPATH.

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
