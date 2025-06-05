#!/bin/bash
# Dotfiles install script

echo "Setting up dotfiles..."

# Initialize submodules if they exist
if [ -f .gitmodules ]; then
    echo "Initializing git submodules..."
    git submodule update --init --recursive
    echo "✓ Git submodules initialized"
fi

# Vim - remove existing and link the vim directory
rm -rf ~/.vim
ln -sf ~/dotfiles/vim ~/.vim
echo "✓ Vim config and colors linked"

# Tmux - remove existing and link the tmux directory
rm -rf ~/.config/tmux
mkdir -p ~/.config
ln -sf ~/dotfiles/tmux ~/.config/tmux
echo "✓ Tmux config linked"

# Git
rm -f ~/.gitconfig
ln -sf ~/dotfiles/git/gitconfig ~/.gitconfig
echo "✓ Git config linked"

# Shell configs
rm -f ~/.zshrc ~/.bash_profile
ln -sf ~/dotfiles/shell/zshrc ~/.zshrc
ln -sf ~/dotfiles/shell/bash_profile ~/.bash_profile
echo "✓ Shell configs linked"

echo "Done! Your dotfiles are set up."
echo "Note: Restart your shell or run 'source ~/.zshrc' to load shell changes"
