#!/bin/bash

# Git Aliases Installation Script for Windows (Git Bash)
# This script installs git aliases for bash environments (Git Bash, WSL, etc.)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

print_detected() {
    echo -e "${CYAN}  ✓${NC} $1"
}

print_not_detected() {
    echo -e "${RED}  ✗${NC} $1"
}

# Git aliases for bash environments
BASH_ALIASES='
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
pr() {
    local draft_flag=""
    if [[ "$1" == "-d" ]]; then
        draft_flag="--draft"
    fi
    
    # Create PR and capture the URL
    local pr_url=$(gpo && gh pr create \
        --base $(git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@") \
        --head $(git branch --show-current) \
        --fill \
        $draft_flag 2>&1 | grep -o 'https://github.com[^[:space:]]*')
    
    if [[ -n "$pr_url" ]]; then
        # Copy to clipboard (cross-platform)
        if command -v pbcopy &> /dev/null; then
            # macOS
            echo "$pr_url" | pbcopy
        elif command -v xclip &> /dev/null; then
            # Linux with xclip
            echo "$pr_url" | xclip -selection clipboard
        elif command -v xsel &> /dev/null; then
            # Linux with xsel
            echo "$pr_url" | xsel --clipboard --input
        elif command -v clip.exe &> /dev/null; then
            # WSL
            echo "$pr_url" | clip.exe
        fi
        
        # Open in browser
        if command -v open &> /dev/null; then
            # macOS
            open "$pr_url"
        elif command -v xdg-open &> /dev/null; then
            # Linux
            xdg-open "$pr_url"
        elif command -v start &> /dev/null; then
            # Windows/WSL
            start "$pr_url"
        fi
        
        echo "✓ PR created and URL copied to clipboard: $pr_url"
    else
        echo "✗ Failed to create PR"
        return 1
    fi
}
'

# Check if we're in a bash-compatible environment
check_bash_available() {
    # We're already running in bash, so bash is available
    if [[ -n "$BASH_VERSION" ]]; then
        return 0
    fi
    
    return 1
}

# Get bash config file path
get_bash_config_file() {
    local config_file="$HOME/.bashrc"
    
    # Check for different bash config files
    if [[ -f "$HOME/.bash_profile" ]]; then
        config_file="$HOME/.bash_profile"
    elif [[ -f "$HOME/.profile" ]]; then
        config_file="$HOME/.profile"
    fi
    
    echo "$config_file"
}

# Check if aliases are already installed in bash
check_bash_aliases_installed() {
    local config_file="$1"
    if [[ -f "$config_file" ]] && grep -q "# Git Aliases - Installed by git-alias installer" "$config_file"; then
        return 0
    else
        return 1
    fi
}

# Install to bash environment
install_to_bash() {
    local config_file=$(get_bash_config_file)
    
    print_status "Installing git aliases to bash environment..."
    print_status "Target file: $config_file"
    
    # Create config file if it doesn't exist
    if [[ ! -f "$config_file" ]]; then
        print_warning "Creating new config file: $config_file"
        touch "$config_file"
    fi
    
    # Check if already installed
    if check_bash_aliases_installed "$config_file"; then
        print_warning "Aliases already installed in bash. Removing old version..."
        # Create backup and remove existing
        cp "$config_file" "$config_file.bak"
        sed -i '/# Git Aliases - Installed by git-alias installer/,/^$/d' "$config_file"
    fi
    
    # Add aliases
    echo "$BASH_ALIASES" >> "$config_file"
    print_success "✓ Git aliases installed to bash environment"
    echo "    File: $config_file"
    echo "    Restart terminal or run: source $config_file"
}

# Show environment detection results
show_environment_detection() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    ENVIRONMENT DETECTION                       ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    print_status "Detected environment:"
    
    if check_bash_available; then
        print_detected "Git Bash / WSL / Bash environment available"
    else
        print_not_detected "Git Bash / WSL / Bash environment not available"
    fi
    
    echo ""
}

# Main installation function
main() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                 GIT ALIASES BASH INSTALLER                     ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        print_status "Download Git from: https://git-scm.com/download/windows"
        exit 1
    fi
    
    # Show environment detection
    show_environment_detection

    # Confirmation prompt
    echo -n "Do you want to continue with the installation? (y/n): "
    read -r confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        print_status "Installation cancelled by user."
        exit 0
    fi
    
    # Install to bash environment
    install_to_bash
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    INSTALLATION COMPLETE                       ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    
    # Check if GitHub CLI is available for the 'pr' alias
    if ! command -v gh &> /dev/null; then
        echo ""
        print_warning "GitHub CLI (gh) is not installed. The 'pr' alias won't work until you install it."
        print_status "Install GitHub CLI: https://cli.github.com/"
        print_status "For Windows: winget install --id GitHub.cli (in PowerShell)"
        print_status "Or download from: https://github.com/cli/cli/releases"
    fi
    
    echo ""
    print_success "Git aliases have been successfully installed! 🚀"
    print_status "You can now use short git commands like 'gst' for 'git status'"
    print_status "To use these aliases in VS Code, set Git Bash as your default terminal:"
    print_status "  1. Press Ctrl+Shift+P in VS Code"
    print_status "  2. Search for 'Terminal: Select Default Profile'"
    print_status "  3. Select 'Git Bash'"
    echo ""
}

# Run the main function
main "$@" 