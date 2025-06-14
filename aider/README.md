# Aider Configuration

This directory contains Aider AI coding assistant configuration for the dotfiles setup.

## Overview

Aider is an AI pair programming tool that works with your local git repositories. This setup provides:
- **Flexible model selection** with easy switching between Ollama models
- **Dotfiles integration** that respects your existing development workflow  
- **Security-conscious defaults** that protect sensitive files
- **Shell aliases** for quick model switching

## Configuration Files

- `aider.conf.yml` - Main configuration (linked to `~/.aider.conf.yml`)
- `aiderignore` - Files/patterns for Aider to ignore (linked to `~/.aiderignore`)
- `setup_aider.sh` - Setup script for installation
- `README.md` - This documentation

## Model Selection Strategy

With 48GB RAM, you can choose the right model for the task:

- **qwen2.5-coder:7b** - Quick tasks, fast responses
- **qwen2.5-coder:14b** - Default balanced option
- **qwen2.5-coder:32b** - Complex tasks, best quality
- **devstral** - Alternative coding model

## Shell Aliases

The following aliases are available (added to your zshrc):

```bash
# Basic Aider with default 14b model
aider

# Quick tasks with 7b model  
aider-quick

# Complex tasks with 32b model
aider-heavy

# Alternative model
aider-alt
```

## Usage Examples

### Basic Usage
```bash
# Start Aider in current project
aider

# Work on specific files
aider src/main.py README.md

# Use different model for complex refactoring
aider-heavy --message "Refactor this entire module for better performance"
```

### Model Switching
```bash
# Quick bug fix
aider-quick --message "Fix the typo in the function name"

# Complex architectural changes  
aider-heavy --message "Redesign this API to be more RESTful"

# Try alternative model
aider-alt --message "Help me understand this complex algorithm"
```

## Integration with Development Workflow

### With Tmux
Run Aider in one tmux pane while editing in Neovim in another:
```bash
# In one pane
aider

# In another pane  
nvim src/
```

### With Git
Aider integrates with your git workflow:
- Auto-commits are disabled by default for review
- Commits are attributed to show AI assistance
- Works with your existing git hooks and workflows

## Security & Privacy

- **Private keys and sensitive configs** are ignored via `aiderignore`
- **Personal package lists** (Brewfile.personal) are protected
- **Local-only** - works with your local Ollama models, no data sent to external services

## Configuration Updates

To modify Aider behavior:

1. **Edit configuration**: `vim ~/dotfiles/aider/aider.conf.yml`
2. **Apply changes**: Configuration is linked, changes take effect immediately
3. **Update ignore patterns**: Edit `~/dotfiles/aider/aiderignore`

## Tips

- Start with the default 14b model and switch as needed
- Use `aider-quick` for simple changes to save time
- Use `aider-heavy` for complex refactoring or when you need the best quality
- Keep commits small and focused for easier review
- Use `--dry-run` flag to preview changes without applying them

## Troubleshooting

### Model not found
```bash
# Check available models
ollama list

# Pull missing model
ollama pull qwen2.5-coder:14b
```

### Configuration not loading
```bash
# Verify symlink
ls -la ~/.aider.conf.yml

# Re-run setup if needed
~/dotfiles/aider/setup_aider.sh
```

### Performance issues
- Use smaller model (7b) for simple tasks
- Check available RAM with `htop`
- Close other resource-intensive applications

This setup provides a powerful, secure, and integrated AI coding assistant that scales with your development needs.
