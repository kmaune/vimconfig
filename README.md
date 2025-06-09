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
- ⚠️ Runs automatically with no prompts
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

./safe_install.sh  # Re-run if needed
```

## Troubleshooting

### Submodules not loading
```bash
git submodule update --init --recursive
```

### Scripts not executable
```bash
find ~/dotfiles/scripts -name "*.sh" -type f -exec chmod +x {} \;
```

### Path not updated
```bash
source ~/.zshrc
```

