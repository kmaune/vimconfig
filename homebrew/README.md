# Homebrew Package Management

This directory contains Homebrew package management for complete system reproducibility.

## Overview

The Homebrew setup provides:
- **Package backup and restore** with Brewfile management
- **Personal package separation** for work/personal-specific tools
- **Automated installation** integrated with dotfiles setup
- **Maintenance utilities** for keeping packages updated and clean

## Files

```
homebrew/
├── README.md                # This file
├── backup_brew.sh          # Main management script
├── Brewfile                # Main package list (tracked in git)
├── Brewfile.personal       # Personal packages (git-ignored)
└── Brewfile.backup.*       # Automatic backups (git-ignored)
```

## Quick Start

### First Time Setup

1. **Export your current packages** (if you have Homebrew installed):
   ```bash
      cd ~/dotfiles/homebrew
         ./backup_brew.sh export
            ```

            2. **Create personal Brewfile** for work/personal-specific packages:
               ```bash
                  ./backup_brew.sh personal
                     ```

                     3. **Commit the main Brewfile** to your dotfiles:
                        ```bash
                           git add Brewfile
                              git commit -m "Add Homebrew package list"
                                 ```

### New Machine Setup

The install scripts will automatically handle Homebrew setup, but you can also run manually:

```bash
# Install main packages
~/dotfiles/homebrew/backup_brew.sh install

# Install personal packages (if you have any)
~/dotfiles/homebrew/backup_brew.sh install Brewfile.personal
```

## Available Commands

### Package Management
```bash
# Export current packages to Brewfile
./backup_brew.sh export

# Install packages from Brewfile
./backup_brew.sh install

# Install from personal Brewfile
./backup_brew.sh install Brewfile.personal
```

### Maintenance
```bash
# Check status and outdated packages
./backup_brew.sh status

# Update Homebrew and all packages
./backup_brew.sh update

# Clean up unused packages
./backup_brew.sh cleanup
```

### Setup
```bash
# Create personal Brewfile template
./backup_brew.sh personal

# Show help
./backup_brew.sh help
```

## Brewfile Structure

### Main Brewfile (Brewfile)
This file contains packages that should be shared across all your machines:

```ruby
# Essential development tools
brew "git"
brew "neovim"
brew "tmux"
brew "fzf"
brew "ripgrep"

# Development languages
brew "node"
brew "python"

# System utilities
brew "htop"
brew "tree"

# GUI applications
cask "iterm2"
cask "visual-studio-code"

# Fonts (if needed)
cask "font-fira-code-nerd-font"
```

### Personal Brewfile (Brewfile.personal)
This file is git-ignored and contains packages specific to you or your work:

```ruby
# Work-specific tools
brew "your-company-cli"
cask "your-work-app"

# Personal preferences
cask "spotify"
cask "discord"

# Mac App Store apps
mas "Xcode", id: 497799835
```

## Integration with Dotfiles

This Homebrew setup integrates seamlessly with your dotfiles:

- **Automatic setup**: Both install scripts will handle Homebrew packages
- **Version controlled**: Main packages are tracked in git
- **Private settings**: Personal packages stay local via `.gitignore`
- **Consistent**: Same package management across all machines

## Workflow Examples

### Adding a New Package

1. **Install the package**:
   ```bash
      brew install some-new-tool
         ```

         2. **Update your Brewfile**:
            ```bash
               ./backup_brew.sh export
                  ```

                  3. **Commit the changes**:
                     ```bash
                        git add Brewfile
                           git commit -m "Add some-new-tool to Brewfile"
                              ```

### Setting Up a New Machine

1. **Clone dotfiles**:
   ```bash
      git clone --recurse-submodules https://github.com/yourusername/dotfiles.git ~/dotfiles
         ```

         2. **Run setup**:
            ```bash
               cd ~/dotfiles
                  ./safe_install.sh
                     ```

                     3. **Add personal packages** (if needed):
                        ```bash
                           ./homebrew/backup_brew.sh personal
                              # Edit Brewfile.personal
                                 ./homebrew/backup_brew.sh install Brewfile.personal
                                    ```

### Regular Maintenance

```bash
# Check what needs updating
./backup_brew.sh status

# Update everything
./backup_brew.sh update

# Clean up unused packages
./backup_brew.sh cleanup

# Update Brewfile if you've installed new things
./backup_brew.sh export
```

## Tips

1. **Keep Brewfile minimal**: Only include packages you actually need on every machine
2. **Use personal Brewfile**: For work-specific or experimental packages
3. **Regular exports**: After installing new packages, remember to export
4. **Clean regularly**: Use the cleanup command to remove unused dependencies
5. **Check status**: Regularly check what packages are outdated

## Troubleshooting

### Homebrew Not Found
If you get "Homebrew not found" errors:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add to PATH (follow Homebrew's instructions)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Package Installation Fails
If some packages fail to install:

1. **Check the output** for specific error messages
2. **Update Homebrew**: `brew update`
3. **Check package availability**: Some packages might be renamed or removed
4. **Install manually**: `brew install package-name` to see specific errors

### Cask Requires Password
Some casks require admin password for installation. This is normal for GUI applications.

### Mac App Store Apps (mas)
To use `mas` (Mac App Store CLI):

1. **Install mas**: `brew install mas`
2. **Sign in to App Store** manually first
3. **Find app IDs**: `mas search "App Name"`

## Security Notes

- **Brewfile.personal is git-ignored**: Keep work-specific packages private
- **Review packages**: Always review what's being installed
- **Backup important data**: Before major updates, backup important work
- **Use official sources**: Stick to official Homebrew formulae when possible

This setup ensures your development environment is fully reproducible while keeping personal preferences private and maintaining system cleanliness.
