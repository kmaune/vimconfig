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

# Aider AI Assistant setup
if [ -f ~/dotfiles/aider/setup_aider.sh ]; then
    chmod +x ~/dotfiles/aider/setup_aider.sh
    ~/dotfiles/aider/setup_aider.sh
fi

# Make scripts executable (if scripts submodule exists)
if [ -d ~/dotfiles/scripts ]; then
    echo "Making scripts executable..."
    find ~/dotfiles/scripts -name "*.sh" -type f -exec chmod +x {} \;
    echo "✓ Scripts made executable"
fi

# Make homebrew script executable
if [ -f ~/dotfiles/homebrew/backup_brew.sh ]; then
    chmod +x ~/dotfiles/homebrew/backup_brew.sh
    echo "✓ Homebrew script made executable"
fi

# Homebrew setup (non-interactive)
if command -v brew &> /dev/null && [ -f ~/dotfiles/homebrew/Brewfile ]; then
    echo "Installing Homebrew packages..."
    ~/dotfiles/homebrew/backup_brew.sh install
elif command -v brew &> /dev/null; then
    echo "✓ Homebrew found but no Brewfile present"
    echo "  Run '~/dotfiles/homebrew/backup_brew.sh export' to create one"
else
    echo "⚠️  Homebrew not found. Install it to manage packages:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
fi

echo "Done! Your dotfiles are set up."
echo "Note: Restart your shell or run 'source ~/.zshrc' to load shell changes"
