#!/bin/bash
# Dotfiles install script

echo "Setting up dotfiles..."

# Vim - link the entire vim directory
ln -sf ~/dotfiles/vim ~/.vim
echo "✓ Vim config and colors linked"

# Tmux - link the entire tmux directory
mkdir -p ~/.config
ln -sf ~/dotfiles/tmux ~/.config/tmux
echo "✓ Tmux config linked"

echo "Done! Your dotfiles are set up."
