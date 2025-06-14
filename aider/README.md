# Aider Configuration

This directory contains Aider AI coding assistant configuration for the dotfiles setup.

## Overview

Aider is an AI pair programming tool that works with your local git repositories. This setup provides:
- **Flexible model selection** with easy switching between local Ollama and cloud OpenRouter models
- **Dotfiles integration** that respects your existing development workflow  
- **Security-conscious defaults** that protect sensitive files
- **Shell aliases** for quick model switching
- **Hybrid local/cloud approach** for optimal performance and reliability

## Configuration Files

- `aider.conf.yml` - Main configuration (linked to `~/.aider.conf.yml`)
- `aiderignore` - Files/patterns for Aider to ignore (linked to `~/.aiderignore`)
- `setup_aider.sh` - Setup script for installation
- `README.md` - This documentation

## Model Selection Strategy

### Local Models (Ollama)
With 48GB RAM, you can choose the right local model for the task:

- **qwen2.5-coder:7b** - Quick tasks, fast responses
- **qwen2.5-coder:32b** - Complex tasks, best quality
- **devstral:24b** - Alternative coding model

### Cloud Models (OpenRouter - Free Tier)
For enhanced reliability when local models struggle:

- **deepseek-chat** - Fast, reliable cloud model for general coding
- **deepseek-r1** - Advanced reasoning model for complex problems
- **qwen-2.5-coder-32b** - High-quality coding model equivalent to local 32B

## Shell Aliases

The following aliases are available (added to your zshrc):

```bash
# Local Ollama models
aider                # Default 14b model
aider-quick         # 7b model (fast)
aider-heavy         # 32b model (thorough)
aider-alt           # Devstral 24b (alternative)

# Cloud OpenRouter models (free tier)
aider-deepseek      # DeepSeek Chat (reliable)
aider-r1            # DeepSeek R1 (reasoning)
aider-qwen          # Qwen Coder 32B (high quality)

# Utility
aider-models        # Show all available configurations
aider-config        # Edit main config file
aider-ignore        # Edit ignore patterns
```

## Usage Examples

### Recommended Workflow
```bash
# Start with fast local model for exploration
aider-quick

# Escalate to cloud when local model struggles
> /model openrouter/deepseek/deepseek-chat:free

# Or start directly with reliable cloud model
aider-deepseek

# Use reasoning model for complex architectural decisions
aider-r1
```

### Basic Usage
```bash
# Start Aider in current project
aider

# Work on specific files
aider src/main.py README.md

# Use different model for complex refactoring
aider-heavy --message "Refactor this entire module for better performance"
```

### Model Switching Mid-Session
```bash
# Switch to cloud model when local struggles
> /model openrouter/deepseek/deepseek-chat:free

# Switch to reasoning model for complex problems
> /model openrouter/deepseek/deepseek-r1:free

# Switch back to local for simple tasks
> /model ollama/qwen2.5-coder:7b
```

## Integration with Development Workflow

### With Tmux
Run Aider in one tmux pane while editing in Neovim in another:
```bash
# In one pane
aider-deepseek

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
- **Hybrid approach** - local models for private work, cloud models when needed
- **API keys** managed via environment variables (not stored in dotfiles)

## Configuration Updates

To modify Aider behavior:

1. **Edit configuration**: `vim ~/dotfiles/aider/aider.conf.yml`
2. **Apply changes**: Configuration is linked, changes take effect immediately
3. **Update ignore patterns**: Edit `~/dotfiles/aider/aiderignore`

## Tips

### Model Selection Strategy
- **Start local**: Use `aider-quick` or `aider` for initial exploration
- **Escalate to cloud**: Switch to `aider-deepseek` when local models struggle with function calling
- **Use reasoning**: Try `aider-r1` for complex architectural decisions or debugging
- **High quality**: Use `aider-qwen` or `aider-heavy` for complex refactoring

### Best Practices
- Keep commits small and focused for easier review
- Use `--dry-run` flag to preview changes without applying them
- Use `aider-models` to remind yourself of available options
- Switch models mid-session based on task complexity

## Troubleshooting

### Local Models
```bash
# Check available models
ollama list

# Pull missing model
ollama pull qwen2.5-coder:14b
```

### Cloud Models
```bash
# Verify API key is set
echo $OPENROUTER_API_KEY

# Test connection
aider-deepseek --message "Hello, test message"
```

### Configuration not loading
```bash
# Verify symlink
ls -la ~/.aider.conf.yml

# Re-run setup if needed
~/dotfiles/aider/setup_aider.sh
```

### Performance issues
- Use smaller local model (7b) for simple tasks
- Check available RAM with `htop`
- Close other resource-intensive applications
- Switch to cloud models if local performance is poor

## OpenRouter Setup

To use the cloud models, you need an OpenRouter API key:

1. **Get API key**: Sign up at [openrouter.ai](https://openrouter.ai) (free tier available)
2. **Set environment variable**: `export OPENROUTER_API_KEY="your-key-here"`
3. **Test**: Run `aider-deepseek` to verify connection

This setup provides a powerful, secure, and integrated AI coding assistant that scales from fast local models to reliable cloud models based on your needs.
