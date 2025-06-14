#!/bin/bash
# Aider setup script

echo "Setting up Aider AI coding assistant..."

# Create symlinks for configuration files
rm -f ~/.aider.conf.yml ~/.aiderignore
ln -sf ~/dotfiles/aider/aider.conf.yml ~/.aider.conf.yml
ln -sf ~/dotfiles/aider/aiderignore ~/.aiderignore
echo "✓ Aider configuration files linked"

# Check if Ollama and models are available
if command -v ollama &> /dev/null; then
    echo "✓ Ollama found"
    
    # Check for required models
    if ollama list | grep -q "qwen2.5-coder:14b"; then
        echo "✓ Default model (qwen2.5-coder:14b) available"
    else
        echo "⚠️  Default model not found. You may want to run:"
        echo "   ollama pull qwen2.5-coder:14b"
    fi
else
    echo "⚠️  Ollama not found. Aider requires Ollama for local models."
    echo "   Install Ollama first: https://ollama.ai"
fi

# Check if aider is installed
if command -v aider &> /dev/null; then
    echo "✓ Aider command available"
else
    echo "⚠️  Aider not found. Install with:"
    echo "   pip install aider-chat"
fi

echo "✓ Aider setup complete!"
echo ""
echo "Usage:"
echo "  aider           # Default 14b model"
echo "  aider-quick     # 7b model for speed"  
echo "  aider-heavy     # 32b model for quality"
echo "  aider-alt       # Alternative devstral model"
echo "  aider-deepseek  # DeepSeek Chat (free, cloud)"
echo "  aider-r1        # DeepSeek R1 (free, reasoning)"
echo "  aider-qwen      # Qwen Coder 32B (free, cloud)"
