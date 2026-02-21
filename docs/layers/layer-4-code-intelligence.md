# Layer 4: Code Intelligence

> AI-ready code analysis and search tools

## Overview

This layer provides semantic code search, AST-aware editing, and security analysis. These tools give AI agents deep understanding of codebases.

## Tools

| Tool | Score | Purpose |
|------|-------|---------|
| **grepai** | 88.4 | Semantic code search with embeddings |
| **ast-grep** | 78.7 | AST structural search and rewrite |
| **probe** | - | AI-friendly code block extraction |
| **semgrep** | 70.4 | Static analysis for security |
| **ctags** | - | Code indexing for navigation |
| **tokei** | - | Code statistics by language |

## Installation

```bash
# grepai (88.4) - semantic code search
pip install grepai
grepai init  # Initialize embeddings

# ast-grep (78.7) - AST structural search
cargo install ast-grep

# probe - AI code extraction
cargo install probe-cli

# semgrep (70.4) - security analysis
pip install semgrep
# Or: brew install semgrep

# ctags - code indexing
sudo apt install -y universal-ctags

# tokei - code statistics
cargo install tokei
```

## grepai - Semantic Code Search

`★ Key Feature: Natural language queries → finds code by meaning, not just text`

### Usage

```bash
# Initialize (builds embeddings)
grepai init

# Semantic search with natural language
grepai search "user authentication flow"
grepai search "error handling middleware"
grepai search "database connection pool"

# JSON output for AI agents
grepai search "authentication" --json

# Compact output (saves ~80% tokens)
grepai search "auth flow" --json --compact

# Token-optimized format
grepai search "JWT validation" --toon

# Limit results
grepai search "API" --limit 5

# Search specific workspace
grepai search "login" --workspace myproject
```

### How It Works

1. Indexes code using vector embeddings
2. Builds semantic understanding of code
3. Matches queries by meaning, not just text
4. Perfect for AI agents exploring codebases

## ast-grep - Structural Search

`★ Key Feature: Search and rewrite code based on AST patterns`

### Usage

```bash
# Find function definitions
sg -p 'fn $NAME($$$PARAMS) $$$BODY' -l rust

# Find all if statements
sg -p 'if ($COND) { $$$BODY }' -l javascript

# Find Python functions
sg -p 'def $NAME($$$PARAMS): $$$BODY' -l python

# Find Go structs
sg -p 'type $NAME struct { $$$FIELDS }' -l go

# Rewrite code
sg -p 'console.log($MSG)' -r 'logger.info($MSG)' -l typescript

# Interactive mode
sg -p 'var $VAR = $VAL' -l javascript -i
```

### Pattern Syntax

| Syntax | Meaning |
|--------|---------|
| `$NAME` | Single metavariable |
| `$$$BODY` | Multiple statements |
| `$$$` | Zero or more |
| `${NAME}text` | With suffix |

### Supported Languages

- Rust
- JavaScript/TypeScript
- Python
- Go
- Java
- C/C++
- Ruby
- And 20+ more

## probe - AI Code Extraction

`★ Key Feature: Extracts code blocks optimized for AI context windows`

### Usage

```bash
# Search with token limit
probe search "prompt injection" ./ --max-tokens 10000

# Query code structures
probe query "fn $NAME($$$PARAMS) $$$BODY" ./src --language rust

# Find Python classes
probe query "class $NAME: $$$BODY" ./src --language python
```

### Features

- Token-aware extraction
- Tree-sitter parsing
- Respects context window limits
- Perfect for feeding code to LLMs

## semgrep - Security Analysis

`★ Key Feature: Find security vulnerabilities with pattern matching`

### Usage

```bash
# Scan current directory
semgrep --config auto .

# Scan with specific rules
semgrep --config p/security-audit .

# Custom rule
semgrep --config my-rules.yml .

# Output formats
semgrep --json .
semgrep --sarif .

# CI/CD mode
semgrep --ci
```

## ctags - Code Indexing

### Usage

```bash
# Generate tags for project
ctags -R .

# With language filter
ctags -R --languages=Python,Rust .

# For specific directory
ctags -R src/

# Use with vim
vim -t function_name
```

## tokei - Code Statistics

### Usage

```bash
# Count lines in project
tokei

# By language
tokei --type rust,python

# Sort by lines
tokei --sort lines

# Output as JSON
tokei --output json

# Exclude directories
tokei --exclude node_modules target
```

## Comparison Table

| Feature | grepai | ast-grep | probe | semgrep |
|---------|--------|----------|-------|---------|
| Search type | Semantic | Structural | Hybrid | Pattern |
| Query format | Natural | AST pattern | Both | Rule |
| AI-friendly | Yes | Yes | Yes | Yes |
| Token control | Yes | No | Yes | No |
| Security | No | No | No | Yes |
| Rewrite | No | Yes | No | No |

## AI Agent Workflow

```bash
# 1. Semantic search to understand codebase
grepai search "user registration flow" --json --compact

# 2. Structural search for specific patterns
sg -p 'async def $NAME($$$): $$$BODY' -l python

# 3. Extract code for AI context
probe search "authentication" ./ --max-tokens 8000

# 4. Security scan
semgrep --config auto .
```
