# Dotfiles

My personal configuration files for various tools and development environments.

## Quick Setup

```bash
git clone --recurse-submodules https://github.com/kmaune/dotfiles.git ~/dotfiles
cd ~/dotfiles
./safe_install.sh
```

## What's Included

- **Shell configuration**: Enhanced zsh with custom prompt, history settings, and aliases
- **Vim**: Complete vim setup with plugins, color scheme, and key mappings
- **Neovim**: Modern Neovim configuration based on kickstart-modular with LSP, completion, and AI tools
- **Tmux**: Terminal multiplexer with custom themes and key bindings
- **Git**: Global git configuration and aliases
- **Scripts**: Utility scripts for development workflows (as git submodule)
- **Conda environments**: Predefined environments for development work
- **Homebrew packages**: System package management with backup/restore functionality

## Installation Scripts

This repo includes two installation scripts for different use cases:

### safe_install.sh (Recommended)

**Use this script when:**
- Setting up on an existing system with potential dotfiles
- You're unsure what configurations already exist
- You want to preserve existing configs as backups
- You want interactive setup options

**What it does:**
- ✅ Backs up existing files (adds `.backup` extension)
- ✅ Interactive conda environment setup
- ✅ Interactive Homebrew package setup
- ✅ Detailed feedback on what's being changed
- ✅ Safe for existing systems

```bash
./safe_install.sh
```

### install.sh (Fast & Clean)

**Use this script when:**
- Fresh system setup (new OS, new user account)
- You want to completely replace existing dotfiles
- Automated environments (CI/CD, containers)
- You're certain you don't need existing configs

**What it does:**
- ⚠️ Directly replaces existing files (no backups)
- ⚠️ Runs automatically with no prompts for most things
- ✅ Fast and straightforward
- ⚠️ Risk of data loss

```bash
./install.sh
```

## Directory Structure

```
~/dotfiles/
├── envs/                    # Conda environment definitions
│   ├── ai_env.yml          # AI/ML development environment
│   ├── base.yml            # Base development environment
│   └── export_env.sh       # Helper script for exporting environments
├── git/                     # Git configuration
│   └── gitconfig           # Global git settings
├── homebrew/                # Homebrew package management
│   ├── backup_brew.sh      # Homebrew backup/restore script
│   ├── Brewfile           # Main package list
│   ├── Brewfile.personal  # Personal packages (git-ignored)
│   └── README.md           # Homebrew-specific documentation
├── shell/                   # Shell configurations
│   ├── zshrc               # Zsh configuration
│   └── bash_profile        # Bash configuration
├── tmux/                    # Tmux configuration and themes
│   ├── tmux.conf           # Main tmux configuration
│   └── themes/             # Tmux color themes (git submodules)
├── vim/                     # Vim configuration
│   ├── vimrc               # Vim configuration
│   └── colors/             # Custom color schemes
├── nvim/                    # Neovim configuration (git submodule)
│   ├── init.lua            # Neovim entry point
│   ├── lua/                # Lua configuration modules
│   └── README.md           # Neovim-specific documentation
├── scripts/                 # Utility scripts (git submodule)
│   ├── openwebui/          # OpenWebUI management scripts
│   └── *.sh                # Various utility scripts
├── ssh/                     # SSH configuration management
│   ├── config              # SSH client configuration
│   ├── setup_ssh.sh        # SSH setup script
│   ├── sshd_config.d/      # SSH server configuration
│   └── README.md           # SSH-specific documentation
├── install.sh              # Fast installation script
├── safe_install.sh         # Safe installation script (recommended)
└── README.md               # This file
```

## Working with Scripts

The `scripts/` directory is a git submodule pointing to a separate repository. This allows you to:

1. **Edit scripts locally**: Make changes in `~/dotfiles/scripts/`
2. **Push to scripts repo**: Commit and push changes directly to the scripts repository
3. **Update dotfiles reference**: Update the dotfiles repo to point to new script versions

### Updating Scripts

```bash
# Edit scripts
cd ~/dotfiles/scripts
vim some_script.sh
git add .
git commit -m "Update script"
git push

# Update dotfiles to reference new script version
cd ~/dotfiles
git add scripts
git commit -m "Update scripts submodule"
git push
```

## Working with Neovim Configuration

The `nvim/` directory is also a git submodule, containing a fork of [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim). This setup allows you to:

1. **Customize your config**: Make personal changes to Neovim configuration
2. **Stay current with upstream**: Pull improvements from the original kickstart project
3. **Maintain version control**: Track exactly which version of the config you're using

### Updating Neovim Configuration

```bash
# Make personal changes
cd ~/dotfiles/nvim
vim lua/kmaune/plugins/new_plugin.lua
git add .
git commit -m "Add new plugin"
git push

# Pull upstream improvements (optional)
git fetch upstream
git merge upstream/main
git push

# Update dotfiles to reference new version
cd ~/dotfiles
git add nvim
git commit -m "Update neovim config"
git push
```

## Conda Environments

The `envs/` directory contains conda environment definitions:

- **base.yml**: Core development environment with essential tools
- **ai_env.yml**: Machine learning and AI development environment
- **export_env.sh**: Helper script for exporting existing environments

### Managing Environments

```bash
# Create environment from definition
conda env create -f envs/ai_env.yml

# Export current environment
cd envs
./export_env.sh my-custom-env

# Update existing environment
conda env update -f envs/base.yml
```

## Homebrew Package Management

The `homebrew/` directory provides complete package management with backup/restore functionality:

- **Brewfile**: Main packages tracked in git (shared across machines)
- **Brewfile.personal**: Personal/work-specific packages (git-ignored)
- **backup_brew.sh**: Management script for all Homebrew operations

### Managing Packages

```bash
# Export current packages to Brewfile
~/dotfiles/homebrew/backup_brew.sh export

# Install packages from Brewfile
~/dotfiles/homebrew/backup_brew.sh install

# Create personal package list
~/dotfiles/homebrew/backup_brew.sh personal

# Check status and updates
~/dotfiles/homebrew/backup_brew.sh status

# Update all packages
~/dotfiles/homebrew/backup_brew.sh update
```

## SSH Configuration

The `ssh/` directory provides secure SSH setup with Tailscale integration:

- **Hardened SSH server configuration** with security best practices
- **Modular configuration** that works with macOS system defaults
- **Public/private split** - generic configs in git, sensitive details git-ignored

### SSH Setup

```bash
# Initial setup (done via install scripts)
~/dotfiles/ssh/setup_ssh.sh

# Edit local settings
nano ~/dotfiles/ssh/sshd_config.d/999-local.conf

# Apply changes
~/dotfiles/ssh/setup_ssh.sh
```

## Updating

To update your dotfiles and all submodules:

```bash
cd ~/dotfiles
git pull
git submodule update --remote --merge

# For neovim config, optionally pull upstream improvements
cd nvim
git fetch upstream
git merge upstream/main  # if you want latest kickstart improvements
git push origin main

cd ..
git add nvim  # update the submodule reference
git commit -m "Update neovim config with upstream changes"
git push

# Update Homebrew packages
./homebrew/backup_brew.sh update
./homebrew/backup_brew.sh export  # Update Brewfile

./safe_install.sh  # Re-run if needed
```

## Complete System Setup Workflow

### First Time Setup (New Machine)

1. **Install Homebrew** (if not already installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Clone dotfiles**:
   ```bash
   git clone --recurse-submodules https://github.com/kmaune/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

3. **Run safe installation**:
   ```bash
   ./safe_install.sh
   ```

4. **Customize personal settings**:
   ```bash
   # Add personal Homebrew packages
   ./homebrew/backup_brew.sh personal
   # Edit homebrew/Brewfile.personal with your packages
   ./homebrew/backup_brew.sh install Brewfile.personal
   
   # Customize SSH if needed
   # Edit ssh/sshd_config.d/999-local.conf
   ./ssh/setup_ssh.sh
   ```

### Regular Maintenance

```bash
cd ~/dotfiles

# Update everything
git pull
git submodule update --remote --merge
./homebrew/backup_brew.sh update

# Export any new packages you've installed
./homebrew/backup_brew.sh export

# Commit and push updates
git add .
git commit -m "Update configurations and packages"
git push
```

### Before Migrating to New Machine

```bash
# Export current state
./homebrew/backup_brew.sh export
./envs/export_env.sh my-current-env

# Commit everything
git add .
git commit -m "Export current system state"
git push
```

## Troubleshooting

### Submodules not loading
```bash
git submodule update --init --recursive
```

### Scripts not executable
```bash
find ~/dotfiles/scripts -name "*.sh" -type f -exec chmod +x {} \;
find ~/dotfiles/homebrew -name "*.sh" -type f -exec chmod +x {} \;
find ~/dotfiles/ssh -name "*.sh" -type f -exec chmod +x {} \;
```

### Homebrew issues
```bash
# Check Homebrew status
~/dotfiles/homebrew/backup_brew.sh status

# Clean up Homebrew
~/dotfiles/homebrew/backup_brew.sh cleanup
```

### Path not updated
```bash
source ~/.zshrc
```

### SSH configuration issues
```bash
# Test SSH configuration
sudo sshd -t

# Check SSH service status
sudo launchctl list | grep ssh
```

This dotfiles setup provides a complete, reproducible development environment that scales from personal projects to professional workflows while maintaining security and flexibility.
