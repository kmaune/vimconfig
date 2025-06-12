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

# Neovim - remove existing and link the neovim directory
rm -rf ~/.config/nvim
ln -sf ~/dotfiles/nvim ~/.config/nvim
echo "✓ Neovim config linked"

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

# SSH configuration
if [ -f ~/dotfiles/ssh/setup_ssh.sh ]; then
    read -p "Would you like to set up SSH configuration? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ~/dotfiles/ssh/setup_ssh.sh
    fi
fi

# Make scripts executable (if scripts submodule exists)
if [ -d ~/dotfiles/scripts ]; then
    echo "Making scripts executable..."
    find ~/dotfiles/scripts -name "*.sh" -type f -exec chmod +x {} \;
    echo "✓ Scripts made executable"
fi

echo "Done! Your dotfiles are set up."
echo "Note: Restart your shell or run 'source ~/.zshrc' to load shell changes"
