#!/bin/bash
# homebrew/backup_brew.sh - Homebrew backup and restore functionality

BREW_DIR="$(dirname "${BASH_SOURCE[0]}")"
BREWFILE="$BREW_DIR/Brewfile"
BREWFILE_PERSONAL="$BREW_DIR/Brewfile.personal"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Homebrew is installed
check_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo -e "${RED}❌ Homebrew not found. Please install Homebrew first:${NC}"
        echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        return 1
    fi
    return 0
}

# Export current Homebrew packages to Brewfile
export_brewfile() {
    echo -e "${BLUE}📦 Exporting Homebrew packages...${NC}"
    
    if ! check_homebrew; then
        return 1
    fi
    
    # Create backup of existing Brewfile if it exists
    if [ -f "$BREWFILE" ]; then
        echo -e "${YELLOW}⚠️  Backing up existing Brewfile...${NC}"
        cp "$BREWFILE" "$BREWFILE.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Generate new Brewfile
    cd "$BREW_DIR"
    brew bundle dump --force --describe
    
    echo -e "${GREEN}✓ Brewfile exported to: $BREWFILE${NC}"
    echo -e "${BLUE}📊 Summary:${NC}"
    
    # Show summary
    local taps=$(grep -c '^tap ' "$BREWFILE" 2>/dev/null || echo "0")
    local brews=$(grep -c '^brew ' "$BREWFILE" 2>/dev/null || echo "0")
    local casks=$(grep -c '^cask ' "$BREWFILE" 2>/dev/null || echo "0")
    local mas=$(grep -c '^mas ' "$BREWFILE" 2>/dev/null || echo "0")
    
    echo "   📂 Taps: $taps"
    echo "   🍺 Brews: $brews" 
    echo "   📱 Casks: $casks"
    echo "   🏪 Mac App Store: $mas"
}

# Install packages from Brewfile
install_brewfile() {
    local brewfile="${1:-$BREWFILE}"
    
    echo -e "${BLUE}📦 Installing Homebrew packages from: $(basename "$brewfile")${NC}"
    
    if ! check_homebrew; then
        return 1
    fi
    
    if [ ! -f "$brewfile" ]; then
        echo -e "${RED}❌ Brewfile not found: $brewfile${NC}"
        return 1
    fi
    
    cd "$BREW_DIR"
    
    # Show what will be installed
    echo -e "${BLUE}📋 Packages to install:${NC}"
    local taps=$(grep -c '^tap ' "$brewfile" 2>/dev/null || echo "0")
    local brews=$(grep -c '^brew ' "$brewfile" 2>/dev/null || echo "0")
    local casks=$(grep -c '^cask ' "$brewfile" 2>/dev/null || echo "0")
    local mas=$(grep -c '^mas ' "$brewfile" 2>/dev/null || echo "0")
    
    echo "   📂 Taps: $taps"
    echo "   🍺 Brews: $brews"
    echo "   📱 Casks: $casks"
    echo "   🏪 Mac App Store: $mas"
    echo
    
    # Ask for confirmation
    read -p "Continue with installation? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        return 0
    fi
    
    # Install packages
    brew bundle install --file="$brewfile"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Homebrew packages installed successfully!${NC}"
    else
        echo -e "${RED}❌ Some packages failed to install. Check the output above.${NC}"
        return 1
    fi
}

# Create a personal Brewfile for user-specific packages
create_personal_brewfile() {
    echo -e "${BLUE}📝 Creating personal Brewfile template...${NC}"
    
    if [ -f "$BREWFILE_PERSONAL" ]; then
        echo -e "${YELLOW}⚠️  Personal Brewfile already exists: $BREWFILE_PERSONAL${NC}"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi
    
    cat > "$BREWFILE_PERSONAL" << 'EOF'
# Personal Homebrew packages
# Add your personal/work-specific packages here
# This file is git-ignored by default

# Example personal packages:
# brew "your-company-cli"
# cask "your-work-app" 
# mas "Your Paid App", id: 123456789

# Development tools specific to you:
# brew "your-preferred-database"
# cask "your-ide"

# Personal apps:
# cask "spotify"
# cask "discord"
EOF
    
    echo -e "${GREEN}✓ Personal Brewfile template created: $BREWFILE_PERSONAL${NC}"
    echo -e "${BLUE}💡 Edit this file to add your personal packages.${NC}"
    echo -e "${BLUE}💡 This file should be git-ignored for privacy.${NC}"
}

# Cleanup unused packages
cleanup_brew() {
    echo -e "${BLUE}🧹 Cleaning up Homebrew...${NC}"
    
    if ! check_homebrew; then
        return 1
    fi
    
    echo "Removing outdated packages..."
    brew cleanup
    
    echo "Checking for unused dependencies..."
    brew autoremove
    
    echo -e "${GREEN}✓ Cleanup complete!${NC}"
}

# Show status and differences
status_brew() {
    echo -e "${BLUE}📊 Homebrew Status${NC}"
    echo
    
    if ! check_homebrew; then
        return 1
    fi
    
    if [ ! -f "$BREWFILE" ]; then
        echo -e "${YELLOW}⚠️  No Brewfile found. Run 'export' to create one.${NC}"
        return 0
    fi
    
    # Show outdated packages
    echo -e "${BLUE}📦 Outdated packages:${NC}"
    local outdated=$(brew outdated)
    if [ -z "$outdated" ]; then
        echo "   None! 🎉"
    else
        echo "$outdated" | sed 's/^/   /'
    fi
    echo
    
    # Show Brewfile status
    echo -e "${BLUE}📋 Brewfile status:${NC}"
    cd "$BREW_DIR"
    brew bundle check --verbose 2>/dev/null || {
        echo -e "${YELLOW}⚠️  Some packages from Brewfile are not installed.${NC}"
        echo -e "${BLUE}💡 Run 'install' to sync your system with the Brewfile.${NC}"
    }
}

# Update Homebrew and packages
update_brew() {
    echo -e "${BLUE}🔄 Updating Homebrew and packages...${NC}"
    
    if ! check_homebrew; then
        return 1
    fi
    
    echo "Updating Homebrew..."
    brew update
    
    echo "Upgrading packages..."
    brew upgrade
    
    echo "Upgrading casks..."
    brew upgrade --cask
    
    cleanup_brew
    
    echo -e "${GREEN}✓ Update complete!${NC}"
    echo -e "${BLUE}💡 Consider running 'export' to update your Brewfile.${NC}"
}

# Main function
main() {
    case "${1:-help}" in
        "export"|"backup")
            export_brewfile
            ;;
        "install"|"restore")
            install_brewfile "$2"
            ;;
        "personal")
            create_personal_brewfile
            ;;
        "cleanup")
            cleanup_brew
            ;;
        "status")
            status_brew
            ;;
        "update")
            update_brew
            ;;
        "help"|*)
            echo -e "${BLUE}🍺 Homebrew Backup & Restore${NC}"
            echo
            echo "Usage: $0 <command>"
            echo
            echo "Commands:"
            echo "  export     Export current packages to Brewfile"
            echo "  install    Install packages from Brewfile"
            echo "  personal   Create personal Brewfile template"
            echo "  status     Show status and outdated packages"
            echo "  update     Update Homebrew and all packages"
            echo "  cleanup    Clean up unused packages"
            echo "  help       Show this help message"
            echo
            echo "Examples:"
            echo "  $0 export                    # Export current setup"
            echo "  $0 install                  # Install from Brewfile"
            echo "  $0 install Brewfile.personal # Install from personal file"
            ;;
    esac
}

# Run main function with all arguments
main "$@"
