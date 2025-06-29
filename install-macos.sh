#!/bin/bash

# Git Aliases Installation Script for macOS/Linux
# This script will add git aliases to your shell configuration file

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Git aliases to be added
ALIASES='
# Git Aliases - Installed by git-alias installer
alias g="git"
alias gst="git status"
alias gp="git push"
alias gl="git pull"
alias gpr="git pull --rebase"
alias grb="git rebase"
alias gf="git fetch"
alias gfa="git fetch --all"
alias gcm="git commit -m"
alias gc="git checkout"
alias gclone="git clone"
alias gr="git remote"
alias gcb="git checkout -b"
alias gbd="git branch -D"
alias gcp="git cherry-pick"
alias gcl="git config --list"
alias glog="git log ."
alias ga="git add"
alias gm="git merge"
alias grs="git reset --soft"
alias grh="git reset --hard"
alias gstash="git stash push -m"
alias gpo="git push origin -u \$(git branch --show-current)"
alias pr="gpo && gh pr create --base \$(git symbolic-ref refs/remotes/origin/HEAD | sed \"s@^refs/remotes/origin/@@\") --head \$(git branch --show-current) --fill --web"
'

# Detect the user's shell and determine config file
detect_shell_config() {
    local shell_name=$(basename "$SHELL")
    local config_file=""
    
    case "$shell_name" in
        "zsh")
            if [[ -f "$HOME/.zshrc" ]]; then
                config_file="$HOME/.zshrc"
            elif [[ -f "$HOME/.zsh_profile" ]]; then
                config_file="$HOME/.zsh_profile"
            else
                config_file="$HOME/.zshrc"
                print_warning "Creating new .zshrc file"
            fi
            ;;
        "bash")
            if [[ -f "$HOME/.bashrc" ]]; then
                config_file="$HOME/.bashrc"
            elif [[ -f "$HOME/.bash_profile" ]]; then
                config_file="$HOME/.bash_profile"
            else
                config_file="$HOME/.bashrc"
                print_warning "Creating new .bashrc file"
            fi
            ;;
        *)
            print_warning "Unsupported shell: $shell_name. Defaulting to .bashrc"
            config_file="$HOME/.bashrc"
            ;;
    esac
    
    echo "$config_file"
}

# Check if aliases are already installed
check_existing_aliases() {
    local config_file="$1"
    if [[ -f "$config_file" ]] && grep -q "# Git Aliases - Installed by git-alias installer" "$config_file"; then
        return 0
    else
        return 1
    fi
}

# Main installation function
main() {
    print_status "Starting Git Aliases installation..."
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    
    # Detect shell configuration file
    CONFIG_FILE=$(detect_shell_config)
    print_status "Detected shell: $(basename "$SHELL")"
    print_status "Configuration file: $CONFIG_FILE"
    
    # Check if aliases are already installed
    if check_existing_aliases "$CONFIG_FILE"; then
        print_warning "Git aliases appear to already be installed in $CONFIG_FILE"
        echo -n "Do you want to reinstall them? (y/N): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            print_status "Installation cancelled."
            exit 0
        fi
        
        # Remove existing aliases
        print_status "Removing existing aliases..."
        sed -i.bak '/# Git Aliases - Installed by git-alias installer/,/^$/d' "$CONFIG_FILE"
    fi
    
    # Add aliases to configuration file
    print_status "Adding git aliases to $CONFIG_FILE..."
    echo "$ALIASES" >> "$CONFIG_FILE"
    
    print_success "Git aliases have been successfully installed!"
    print_status "Configuration updated in: $CONFIG_FILE"
    
    # Check if GitHub CLI is available for the 'pr' alias
    if ! command -v gh &> /dev/null; then
        print_warning "GitHub CLI (gh) is not installed. The 'pr' alias won't work until you install it."
        print_status "Install GitHub CLI: https://cli.github.com/"
    fi
    
    echo ""
    print_status "To start using the aliases, either:"
    echo "  1. Restart your terminal, or"
    echo "  2. Run: source $CONFIG_FILE"
    echo ""
    print_success "Installation complete! Happy coding! 🚀"
}

# Run the main function
main "$@" 