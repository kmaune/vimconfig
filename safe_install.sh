#!/bin/bash
# Safe dotfiles install script with backup functionality and conda environment setup

echo "Setting up dotfiles safely..."

# Initialize submodules if they exist
if [ -f .gitmodules ]; then
    echo "Initializing git submodules..."
    git submodule update --init --recursive
    echo "✓ Git submodules initialized"
fi

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

# Neovim  
safe_link ~/dotfiles/nvim ~/.config/nvim
echo "✓ Neovim config linked"

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

# Homebrew setup
setup_homebrew() {
    echo "Setting up Homebrew packages..."
    
    if ! command -v brew &> /dev/null; then
        echo "⚠️  Homebrew not found. Install it first:"
        echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        return 1
    fi
    
    if [ -f ~/dotfiles/homebrew/Brewfile ]; then
        echo "📦 Found Brewfile. Installing packages..."
        ~/dotfiles/homebrew/backup_brew.sh install
    else
        echo "📦 No Brewfile found. You can create one with:"
        echo "   ~/dotfiles/homebrew/backup_brew.sh export"
        
        read -p "Would you like to create a personal Brewfile template? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ~/dotfiles/homebrew/backup_brew.sh personal
        fi
    fi
}

# Conda environment setup
setup_conda_env() {
    echo "Setting up conda environment..."
    
    # Check if conda is available
    if ! command -v conda &> /dev/null; then
        echo "⚠️  Conda not found. Skipping environment setup."
        echo "   Install Anaconda/Miniconda first, then run this script again."
        return 1
    fi
    
    # Look for environment files in priority order
    if [ -f ~/dotfiles/envs/base.yml ]; then
        ENV_FILE="~/dotfiles/envs/base.yml"
    elif [ -f ~/dotfiles/base.yml ]; then
        ENV_FILE="~/dotfiles/base.yml"
    elif [ -f ~/dotfiles/envs/environment.yml ]; then
        ENV_FILE="~/dotfiles/envs/environment.yml"
    elif [ -f ~/dotfiles/environment.yml ]; then
        ENV_FILE="~/dotfiles/environment.yml"
    else
        echo "⚠️  No environment file found. Skipping conda environment setup."
        echo "   Create ~/dotfiles/envs/base.yml to enable automatic environment setup."
        return 1
    fi
    
    # Get environment name from the file
    ENV_NAME=$(grep 'name:' "$ENV_FILE" | head -1 | cut -d' ' -f2)
    
    # Check if environment already exists
    if conda env list | grep -q "^$ENV_NAME "; then
        echo "📦 Environment '$ENV_NAME' already exists."
        read -p "Would you like to update it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            conda env update -f "$ENV_FILE"
            echo "✓ Conda environment updated"
        fi
    else
        echo "📦 Creating conda environment from $ENV_FILE..."
        conda env create -f "$ENV_FILE"
        echo "✓ Conda environment created"
    fi
    
    echo "   Activate with: conda activate $ENV_NAME"
}

# Ask user if they want to set up conda environment
read -p "Would you like to set up the conda environment? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    setup_conda_env
fi

# Ask user if they want to set up Homebrew packages
read -p "Would you like to set up Homebrew packages? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    setup_homebrew
fi

echo "Done! Your dotfiles are set up safely."
echo "Note: Any existing files were backed up with .backup extension"
echo "Restart your shell or run 'source ~/.zshrc' to load shell changes"
