# Contributing to Better AI Usage

Thank you for your interest in contributing! This project aims to provide the most optimized terminal environment for AI agents.

## Ways to Contribute

### 1. Report Issues

- Use the [issue tracker](https://github.com/rldyourmnd/better-ai-usage/issues)
- Check for existing issues before creating new ones
- Provide detailed reproduction steps

### 2. Suggest New Tools

- Open an issue with the `tool-suggestion` label
- Include Context7 benchmark score if available
- Explain the benefit for AI agent workflows

### 3. Improve Documentation

- Fix typos or unclear instructions
- Add examples and use cases
- Translate documentation

### 4. Submit Configuration Improvements

- Fork the repository
- Create a feature branch
- Submit a pull request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/better-ai-usage.git
cd better-ai-usage

# Create a branch
git checkout -b feature/your-feature

# Make changes and commit
git add .
git commit -m "feat: your feature description"

# Push and create PR
git push origin feature/your-feature
```

## Pull Request Guidelines

1. **One feature per PR** - Keep changes focused
2. **Test your changes** - Verify scripts work on fresh systems
3. **Update documentation** - Keep README and docs current
4. **Follow conventions** - Match existing code style

## Code Style

### Shell Scripts

- Use `#!/usr/bin/env bash` shebang
- Enable strict mode: `set -euo pipefail`
- Add comments for complex operations
- Use meaningful variable names

### Configuration Files

- Include comments explaining options
- Follow tool-specific conventions
- Keep minimal but complete

## Tool Evaluation Criteria

When suggesting new tools, consider:

| Criterion | Weight |
|-----------|--------|
| Performance (benchmark) | 40% |
| AI-agent compatibility | 25% |
| Documentation quality | 15% |
| Active maintenance | 10% |
| Community adoption | 10% |

## Questions?

Open an issue with the `question` label or start a discussion.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
