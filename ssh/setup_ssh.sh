#!/bin/bash
# SSH configuration setup script for macOS

echo "Setting up SSH configuration..."

# Check for local config
if [ ! -f ~/dotfiles/ssh/sshd_config.d/999-local.conf ]; then
    echo "⚠️  Creating local config from example..."
    echo "   Please edit ssh/sshd_config.d/999-local.conf with your settings"
    cp ~/dotfiles/ssh/sshd_config.d/999-local.conf.example ~/dotfiles/ssh/sshd_config.d/999-local.conf
fi

# Create backup of sshd_config.d if it has custom files
if [ -d /etc/ssh/sshd_config.d ] && [ "$(ls -A /etc/ssh/sshd_config.d | grep -v '100-macos.conf')" ]; then
    sudo cp -r /etc/ssh/sshd_config.d /etc/ssh/sshd_config.d.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null || true
    echo "✓ Backed up existing custom sshd configs"
fi

# Install our hardening configs
sudo cp ~/dotfiles/ssh/sshd_config.d/900-hardening.conf /etc/ssh/sshd_config.d/
sudo cp ~/dotfiles/ssh/sshd_config.d/999-local.conf /etc/ssh/sshd_config.d/
echo "✓ SSH hardening configs installed"

# Set up SSH client config
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Link SSH client config if it exists and has content
if [ -s ~/dotfiles/ssh/config ]; then
    if [ -f ~/.ssh/config ]; then
        mv ~/.ssh/config ~/.ssh/config.backup.$(date +%Y%m%d_%H%M%S)
        echo "✓ Backed up existing SSH client config"
    fi
    ln -sf ~/dotfiles/ssh/config ~/.ssh/config
    chmod 600 ~/.ssh/config
    echo "✓ SSH client config linked"
fi

# Test SSH configuration
echo "Testing SSH configuration..."
sudo sshd -t
if [ $? -eq 0 ]; then
    echo "✓ SSH configuration is valid"
    
    # Restart SSH service
    sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist 2>/dev/null || true
    sudo launchctl load /System/Library/LaunchDaemons/ssh.plist
    echo "✓ SSH service restarted"
else
    echo "❌ SSH configuration has errors - not restarting service"
    exit 1
fi

echo ""
echo "SSH configuration complete!"
echo "Remember to:"
echo "1. Edit ssh/sshd_config.d/999-local.conf with your username"
echo "2. Set up SSH keys for passwordless authentication"
echo "3. Add Tailscale IP restriction when ready"
