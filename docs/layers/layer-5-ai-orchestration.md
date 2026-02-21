# Layer 5: AI Orchestration

> User-provided AI CLI tools for multi-model workflows

## Overview

This layer consists of user-provided AI CLI tools. The environment is optimized to work seamlessly with these tools.

## Tools (User-Provided)

| Tool | Provider | Purpose |
|------|----------|---------|
| **claude CLI** | Anthropic | Claude integration |
| **gemini CLI** | Google | Gemini integration |
| **codex CLI** | OpenAI | Codex integration |

## Environment Optimization

The terminal environment is configured for optimal AI agent performance:

### WezTerm Configuration

- **local_echo_threshold_ms=10**: Predictive echo for minimal perceived latency
- **WebGPU + Vulkan**: Fast rendering for large outputs
- **Built-in multiplexer**: Parallel agent sessions

### Shell Configuration

- **~30ms startup**: Fast shell for frequent command execution
- **Autosuggestions**: Learn from AI command patterns
- **History sync (Atuin)**: Share commands across machines

### Tool Integration

```bash
# grepai for semantic code search
grepai search "error handling" --json --compact | claude "Analyze this code"

# ast-grep for structural analysis
sg -p 'fn $NAME($$$PARAMS) $$$BODY' -l rust | gemini "Document these functions"

# probe for context extraction
probe search "auth" ./ --max-tokens 8000 | codex "Review security"
```

## Multi-Model Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│  MULTI-MODEL AI WORKFLOW                                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. EXPLORATION: Gemini CLI (fast, good for research)          │
│     gemini -p "Research best practices for X"                  │
│                                                                 │
│  2. PLANNING: Claude CLI (deep reasoning)                       │
│     claude "Create implementation plan for feature Y"           │
│                                                                 │
│  3. CRITIQUE: Codex CLI (independent review)                   │
│     codex exec "Review this plan for issues"                   │
│                                                                 │
│  4. IMPLEMENTATION: Claude CLI                                  │
│     claude "Implement according to plan"                        │
│                                                                 │
│  5. REVIEW: All models independently                            │
│     → Cross-verification                                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Performance Benefits

| Metric | Impact |
|--------|--------|
| Shell startup | 30x faster → AI can spawn shells quickly |
| Input latency | 10x faster → Real-time AI interaction |
| Search speed | 10x faster → Faster code understanding |
| History sync | Enabled → Learn from all machines |

## Best Practices

1. **Use grepai for code discovery**: Semantic search finds relevant code faster
2. **Use ast-grep for refactoring**: Structural patterns ensure correctness
3. **Use probe for context**: Token limits respected automatically
4. **Use zoxide for navigation**: AI learns frequently accessed directories
5. **Use Atuin for history**: AI can leverage history from all machines
