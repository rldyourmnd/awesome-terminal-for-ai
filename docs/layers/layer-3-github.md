# Layer 3: GitHub & Git

> Complete git and GitHub automation without leaving terminal

## Overview

This layer provides full GitHub functionality in the terminal, plus enhanced git workflows with beautiful diffs and visual UI.

## Tools

| Tool | Score | Purpose |
|------|-------|---------|
| **gh CLI** | 83.2 | Complete GitHub control in terminal |
| **lazygit** | 46 | Visual git UI for staging, commits, pushes |
| **delta** | - | Beautiful git diffs with syntax highlighting |
| **CodeQL** | 73.9 | Semantic code analysis for security |
| **Greptile** | 60 | AI code review for pull requests |

## Installation

```bash
# gh CLI (83.2) - GitHub in terminal
sudo apt install -y gh
# Or: brew install gh

# Authenticate
gh auth login

# lazygit (46) - Git TUI
sudo apt install -y lazygit
# Or: brew install lazygit

# delta - Git diff viewer (already installed in many setups)
cargo install git-delta

# Configure git to use delta
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global merge.conflictstyle diff3
git config --global diff.colorMoved default
```

## gh CLI Usage

### Repository Management

```bash
# Create repository
gh repo create my-project --public --clone

# Clone repository
gh repo clone owner/repo

# Fork repository
gh repo fork owner/repo --clone

# View repository
gh repo view owner/repo

# List repositories
gh repo list --limit 50

# Delete repository (with confirmation)
gh repo delete owner/repo
```

### Pull Requests

```bash
# Create PR
gh pr create --title "Feature" --body "Description"

# List PRs
gh pr list --state open

# View PR
gh pr view 123

# Checkout PR
gh pr checkout 123

# Merge PR
gh pr merge 123 --merge

# Approve PR
gh pr review 123 --approve

# Request review
gh pr edit 123 --add-reviewer username
```

### Issues

```bash
# Create issue
gh issue create --title "Bug" --body "Description"

# List issues
gh issue list --state open

# View issue
gh issue view 123

# Close issue
gh issue close 123

# Add label
gh issue edit 123 --add-label "bug"
```

### Workflows

```bash
# List workflows
gh workflow list

# View workflow
gh workflow view "CI"

# Run workflow
gh workflow run "CI"

# View run
gh run view

# Watch run
gh run watch
```

### Gists

```bash
# Create gist
gh gist create file.txt --public

# List gists
gh gist list

# View gist
gh gist view ID
```

## lazygit Usage

```bash
# Start lazygit
lazygit

# Or with custom config
lazygit -c ~/.config/lazygit/config.yml
```

### Key Bindings

| Key | Action |
|-----|--------|
| `?` | Help |
| `j/k` | Navigate |
| `h/l` | Switch panels |
| `a` | Stage all |
| `c` | Commit |
| `P` | Push |
| `p` | Pull |
| `m` | Merge |
| `r` | Rebase |
| `x` | Custom command |
| `q` | Quit |

## delta Configuration

```bash
# Set as git pager
git config --global core.pager delta

# Enable line numbers
git config --global delta.line-numbers true

# Enable side-by-side view
git config --global delta.side-by-side true

# Set theme
git config --global delta.syntax-theme "Catppuccin Mocha"
```

### delta Features

- Syntax highlighting
- Line numbers
- Side-by-side view
- Word-level diff
- Git blame integration
- Hyperlinks

## Git Aliases

```bash
# Add to ~/.gitconfig
[alias]
    co = checkout
    br = branch
    ci = commit
    st = status
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = lazygit
    df = diff
    lg = log --oneline --graph --all
```

## Workflow Examples

### Create PR from CLI

```bash
# Create branch
git checkout -b feature/my-feature

# Make changes and commit
git add .
git commit -m "feat: add new feature"

# Push and create PR
git push -u origin feature/my-feature
gh pr create --title "Add new feature" --body "Description"
```

### Quick Review

```bash
# Checkout PR
gh pr checkout 123

# Review with lazygit
lazygit

# Approve
gh pr review 123 --approve --body "LGTM!"
```

### Bulk Operations

```bash
# List all open PRs needing review
gh pr list --state open --reviewer @me

# Close multiple issues
gh issue close 1 2 3

# View all PRs by author
gh pr list --author username
```
