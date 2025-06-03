#!/bin/bash
# Safe dotfiles install script with backup functionality

echo "Setting up dotfiles safely..."

# Function to safely create symlinks with backup
safe_link() {
    local source="$1"
    local target="$2"
    
    # If target exists and is NOT a symlink, back it up
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "⚠️  Backing up existing $target to $target.backup"
        mv "$target" "$target.backup"
    fi
    
    # Remove existing symlink or file, then create new symlink
    rm -rf "$target"
    ln -sf "$source" "$target"
}

# Vim
safe_link ~/dotfiles/vim ~/.vim
echo "✓ Vim config and colors linked"

# Tmux
mkdir -p ~/.config
safe_link ~/dotfiles/tmux ~/.config/tmux
echo "✓ Tmux config linked"

# Git
safe_link ~/dotfiles/git/gitconfig ~/.gitconfig
echo "✓ Git config linked"

# Shell configs
safe_link ~/dotfiles/shell/zshrc ~/.zshrc
safe_link ~/dotfiles/shell/bash_profile ~/.bash_profile
echo "✓ Shell configs linked"

echo "Done! Your dotfiles are set up safely."
echo "Note: Any existing files were backed up with .backup extension"
echo "Restart your shell or run 'source ~/.zshrc' to load shell changes"
