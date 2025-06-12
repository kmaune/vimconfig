# SSH Configuration

This directory contains SSH configuration management for secure remote access via Tailscale.

## Overview

The SSH setup provides:
- **Hardened SSH server configuration** with security best practices
- **Modular configuration** that works with macOS system defaults
- **Public/private split** - generic configs in git, sensitive details git-ignored
- **Easy deployment** integrated with the dotfiles install scripts

## Files

```
ssh/
├── README.md                           # This file
├── setup_ssh.sh                       # Main setup script
├── config                             # SSH client configuration
└── sshd_config.d/
    ├── 900-hardening.conf             # Security hardening (public)
        ├── 999-local.conf.example         # Local customization template
            └── 999-local.conf                 # Your local settings (git-ignored)
            ```

## Quick Start

1. **Initial setup** (done via install scripts):
   ```bash
      ~/dotfiles/ssh/setup_ssh.sh
         ```

         2. **Edit local settings**:
            ```bash
               nano ~/dotfiles/ssh/sshd_config.d/999-local.conf
                  ```

                  3. **Apply changes**:
                     ```bash
                        ~/dotfiles/ssh/setup_ssh.sh
                           ```

## Checking SSH Status

### Is SSH enabled?
```bash
# Check if Remote Login is enabled
sudo systemsetup -getremotelogin

# Expected output if enabled:
# Remote Login: On
```

### Is SSH service running?
```bash
# Check if SSH daemon is loaded
sudo launchctl list | grep ssh

# Check what's listening on SSH port
sudo lsof -i :22

# Detailed service status
sudo launchctl print system/com.openssh.sshd
```

### Test SSH configuration
```bash
# Test config syntax without restarting
sudo sshd -t

# Should return nothing if config is valid
```

## Enabling/Disabling SSH

### Via Command Line
```bash
# Enable SSH
sudo systemsetup -setremotelogin on

# Disable SSH
sudo systemsetup -setremotelogin off
```

### Via GUI (Alternative)
1. Open **System Settings**
2. Go to **General → Sharing**
3. Toggle **Remote Login** on/off
4. Choose which users can access

## Setting Up SSH Keys

SSH keys provide secure, passwordless authentication and are highly recommended.

### Step 1: Generate SSH Key Pair

```bash
# Generate a new key pair specifically for this connection
ssh-keygen -t ed25519 -f ~/.ssh/tailscale_key -C "description-of-this-key"

# Example:
ssh-keygen -t ed25519 -f ~/.ssh/tailscale_ipad_key -C "iPad-to-Mac-via-Tailscale"
```

**Options explained:**
- `-t ed25519`: Use modern, secure Ed25519 algorithm
- `-f ~/.ssh/tailscale_key`: Save to specific filename
- `-C "comment"`: Add a comment to identify the key

### Step 2: Add Public Key to Authorized Keys

```bash
# Add your public key to authorized_keys
cat ~/.ssh/tailscale_key.pub >> ~/.ssh/authorized_keys

# Set proper permissions
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

### Step 3: Copy Private Key to Client Device

```bash
# Display private key to copy to your client device (iPad, etc.)
cat ~/.ssh/tailscale_key

# Copy this entire output to your client device
```

### Step 4: Configure Client Device

**On iPad (a-Shell mini) or other client:**

```bash
# Create SSH directory
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Create private key file
nano ~/.ssh/tailscale_key
# Paste the private key content here

# Set proper permissions
chmod 600 ~/.ssh/tailscale_key

# Test the connection
ssh -i ~/.ssh/tailscale_key username@100.x.x.x
```

### Step 5: Create SSH Client Config (Optional but Recommended)

**On client device, create `~/.ssh/config`:**

```bash
nano ~/.ssh/config

# Add this content:
Host mac
    HostName 100.x.x.x
        User yourusername
            IdentityFile ~/.ssh/tailscale_key
                IdentitiesOnly yes

                Host macbook
                    HostName 100.x.x.x
                        User yourusername
                            IdentityFile ~/.ssh/tailscale_key
                                IdentitiesOnly yes
                                ```

                                Now you can connect with just: `ssh mac`

### Step 6: Disable Password Authentication (Recommended)

Once SSH keys are working:

```bash
# Edit local SSH config
nano ~/dotfiles/ssh/sshd_config.d/999-local.conf

# Change this line:
PasswordAuthentication no

# Apply changes
~/dotfiles/ssh/setup_ssh.sh
```

## Adding Tailscale IP Restriction

For maximum security, restrict SSH to only accept connections from your Tailscale network.

### Step 1: Get Your Tailscale IP

```bash
# Get your machine's Tailscale IP
tailscale ip -4

# Note the IP (something like 100.x.x.x)
```

### Step 2: Add IP Restriction

```bash
# Edit local SSH config
nano ~/dotfiles/ssh/sshd_config.d/999-local.conf

# Add or uncomment this line:
ListenAddress 100.x.x.x  # Replace with your actual Tailscale IP

# Apply changes
~/dotfiles/ssh/setup_ssh.sh
```

### Step 3: Verify Restriction

```bash
# Check what interfaces SSH is listening on
sudo lsof -i :22

# Should only show your Tailscale IP, not 0.0.0.0 or your regular network IP
```

**⚠️ Warning:** This makes SSH only accessible via Tailscale. Make sure Tailscale is working properly before applying this restriction.

## Troubleshooting

### SSH Connection Refused

1. **Check if SSH is enabled:**
   ```bash
      sudo systemsetup -getremotelogin
         ```

         2. **Check SSH service status:**
            ```bash
               sudo launchctl list | grep ssh
                  ```

                  3. **Test SSH configuration:**
                     ```bash
                        sudo sshd -t
                           ```

                           4. **Check firewall settings:**
                              - System Settings → Network → Firewall
                                 - Ensure SSH/Remote Login is allowed

### SSH Key Authentication Failing

1. **Check key permissions:**
   ```bash
      ls -la ~/.ssh/
         # authorized_keys should be 600
            # .ssh directory should be 700
               ```

               2. **Verify key is in authorized_keys:**
                  ```bash
                     cat ~/.ssh/authorized_keys
                        ```

                        3. **Test with verbose output:**
                           ```bash
                              ssh -v -i ~/.ssh/tailscale_key username@100.x.x.x
                                 ```

                                 4. **Check SSH server logs:**
                                    ```bash
                                       sudo log show --predicate 'process == "sshd"' --last 10m
                                          ```

### Tailscale Connection Issues

1. **Check Tailscale status:**
   ```bash
      tailscale status
         ```

         2. **Verify both devices are connected:**
            - Both should show as "online" in Tailscale status

            3. **Test basic connectivity:**
               ```bash
                  ping 100.x.x.x  # Your target machine's Tailscale IP
                     ```

## Security Best Practices

### Implemented by Default
- ✅ Root login disabled
- ✅ Empty passwords disabled
- ✅ Limited login attempts (3 max)
- ✅ Limited concurrent sessions (5 max)
- ✅ X11 forwarding disabled
- ✅ Connection timeout (15 minutes idle)

### Recommended Additional Steps
- 🔑 **Use SSH keys** instead of passwords
- 🌐 **Restrict to Tailscale IP** for network-level security
- 👤 **Limit allowed users** to only necessary accounts
- 📝 **Monitor SSH logs** periodically
- 🔄 **Keep SSH keys rotated** (replace old keys periodically)

### File Permissions
```bash
# SSH directory and files should have restrictive permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_* ~/.ssh/*_key  # Private keys
chmod 644 ~/.ssh/*.pub              # Public keys
```

## Advanced Configuration

### Multiple SSH Keys
You can have different keys for different purposes:

```bash
# Work laptop key
ssh-keygen -t ed25519 -f ~/.ssh/work_laptop_key -C "work-laptop-to-server"

# Personal iPad key  
ssh-keygen -t ed25519 -f ~/.ssh/ipad_key -C "ipad-to-server"

# Add both to authorized_keys
cat ~/.ssh/work_laptop_key.pub >> ~/.ssh/authorized_keys
cat ~/.ssh/ipad_key.pub >> ~/.ssh/authorized_keys
```

### Port Forwarding (Optional)
If you need to forward ports through SSH:

```bash
# Edit local config to allow port forwarding
nano ~/dotfiles/ssh/sshd_config.d/999-local.conf

# Add:
AllowTcpForwarding yes
GatewayPorts no  # For security, only local forwarding
```

### Custom SSH Port (Optional)
To use a non-standard SSH port:

```bash
# Edit local config
nano ~/dotfiles/ssh/sshd_config.d/999-local.conf

# Add:
Port 2222  # Or any port between 1024-65535

# Remember to update client connections:
ssh -p 2222 username@100.x.x.x
```

## Integration with Dotfiles

This SSH configuration integrates with the broader dotfiles system:

- **Automatic setup**: SSH config is offered during `./safe_install.sh`
- **Version controlled**: All non-sensitive configs are in git
- **Private settings**: Sensitive details in git-ignored `999-local.conf`
- **Consistent**: Same security standards across all machines
- **Portable**: Easy to deploy on new machines

## Getting Help

If you encounter issues:

1. **Check this README** for troubleshooting steps
2. **Test each component** individually (Tailscale, SSH, keys)
3. **Use verbose SSH output** for debugging: `ssh -v`
4. **Check system logs** for SSH daemon errors
5. **Verify file permissions** on SSH keys and configs

Remember: SSH + Tailscale provides a secure, encrypted tunnel for remote access. Take time to set it up properly for the best security and usability.
