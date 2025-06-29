#!/bin/bash

# Git Aliases Cross-Environment Installation Script for Windows
# This script can install git aliases to both Git Bash and PowerShell

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
alias pr="gpo && gh pr create --base \$(git symbolic-ref refs/remotes/origin/HEAD | sed \"s@^refs/remotes/origin/@@\") --head \$(git branch --show-current) --fill --web"
'

# Git aliases for PowerShell
POWERSHELL_FUNCTIONS='
# Git Aliases - Installed by git-alias installer
function g { git $args }
function gst { git status $args }
function gp { git push $args }
function gl { git pull $args }
function gpr { git pull --rebase $args }
function grb { git rebase $args }
function gf { git fetch $args }
function gfa { git fetch --all $args }
function gcm { git commit -m $args }
function gc { git checkout $args }
function gclone { git clone $args }
function gr { git remote $args }
function gcb { git checkout -b $args }
function gbd { git branch -D $args }
function gcp { git cherry-pick $args }
function gcl { git config --list $args }
function glog { git log . $args }
function ga { git add $args }
function gm { git merge $args }
function grs { git reset --soft $args }
function grh { git reset --hard $args }
function gstash { git stash push -m $args }
function gpo { 
    $currentBranch = git branch --show-current
    git push origin -u $currentBranch
}
function pr { 
    gpo
    $currentBranch = git branch --show-current
    $defaultBranch = git symbolic-ref refs/remotes/origin/HEAD | ForEach-Object { $_ -replace "^refs/remotes/origin/", "" }
    gh pr create --base $defaultBranch --head $currentBranch --fill --web
}
'

# Check if PowerShell is available
check_powershell_available() {
    # Try different ways to detect PowerShell availability
    if command -v powershell &> /dev/null || command -v pwsh &> /dev/null; then
        return 0
    fi
    
    # Check Windows-specific locations
    if [[ -f "/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe" ]] || 
       [[ -f "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe" ]]; then
        return 0
    fi
    
    # Check if we can access PowerShell profile path (indicates PowerShell is available)
    if [[ -n "$USERPROFILE" ]]; then
        local ps_profile_dir
        if [[ "$OSTYPE" == "msys" ]]; then
            ps_profile_dir="$USERPROFILE/Documents/WindowsPowerShell"
        else
            ps_profile_dir="$(wslpath "$USERPROFILE" 2>/dev/null)/Documents/WindowsPowerShell" 2>/dev/null || true
        fi
        
        if [[ -n "$ps_profile_dir" ]] && [[ -d "$(dirname "$ps_profile_dir")" ]]; then
            return 0
        fi
    fi
    
    return 1
}

# Check if we're in a bash-compatible environment
check_bash_available() {
    # We're already running in bash, so bash is available
    if [[ -n "$BASH_VERSION" ]]; then
        return 0
    fi
    
    return 1
}

# Get PowerShell profile path
get_powershell_profile_path() {
    local profile_path=""
    
    if [[ -n "$USERPROFILE" ]]; then
        if [[ "$OSTYPE" == "msys" ]]; then
            # Git Bash on Windows
            profile_path="$USERPROFILE/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
        else
            # WSL
            local userprofile_unix=$(wslpath "$USERPROFILE" 2>/dev/null) || return 1
            profile_path="$userprofile_unix/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
        fi
    fi
    
    echo "$profile_path"
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

# Check if aliases are already installed in PowerShell
check_powershell_aliases_installed() {
    local profile_path="$1"
    if [[ -f "$profile_path" ]] && grep -q "# Git Aliases - Installed by git-alias installer" "$profile_path"; then
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

# Install to PowerShell environment
install_to_powershell() {
    local profile_path=$(get_powershell_profile_path)
    
    if [[ -z "$profile_path" ]]; then
        print_error "Could not determine PowerShell profile path"
        return 1
    fi
    
    print_status "Installing git aliases to PowerShell environment..."
    print_status "Target file: $profile_path"
    
    # Create PowerShell profile directory if it doesn't exist
    local profile_dir=$(dirname "$profile_path")
    if [[ ! -d "$profile_dir" ]]; then
        print_warning "Creating PowerShell profile directory: $profile_dir"
        mkdir -p "$profile_dir"
    fi
    
    # Create profile file if it doesn't exist
    if [[ ! -f "$profile_path" ]]; then
        print_warning "Creating new PowerShell profile: $profile_path"
        touch "$profile_path"
    fi
    
    # Check if already installed
    if check_powershell_aliases_installed "$profile_path"; then
        print_warning "Aliases already installed in PowerShell. Removing old version..."
        # Create backup and remove existing
        cp "$profile_path" "$profile_path.bak"
        sed -i '/# Git Aliases - Installed by git-alias installer/,/^$/d' "$profile_path"
    fi
    
    # Add functions
    echo "$POWERSHELL_FUNCTIONS" >> "$profile_path"
    print_success "✓ Git aliases installed to PowerShell environment"
    echo "    File: $profile_path"
    echo "    Restart PowerShell or run: . \$PROFILE"
}

# Show environment detection results
show_environment_detection() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    ENVIRONMENT DETECTION                      ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    print_status "Detected environments:"
    
    if check_bash_available; then
        print_detected "Git Bash / WSL / Bash environment available"
    else
        print_not_detected "Git Bash / WSL / Bash environment not available"
    fi
    
    if check_powershell_available; then
        print_detected "PowerShell environment available"
    else
        print_not_detected "PowerShell environment not available"
    fi
    echo ""
}

# Show installation menu
show_installation_menu() {
    local bash_available=false
    local powershell_available=false
    
    if check_bash_available; then
        bash_available=true
    fi
    
    if check_powershell_available; then
        powershell_available=true
    fi
    
    if [[ "$bash_available" == false && "$powershell_available" == false ]]; then
        print_error "No compatible environments detected!"
        print_status "Please make sure you have Git Bash or PowerShell installed."
        exit 1
    fi
    
    echo -e "${GREEN}Which environments would you like to install git aliases to?${NC}"
    echo ""
    
    local menu_options=()
    local option_num=1
    
    if [[ "$bash_available" == true ]]; then
        echo "  $option_num) Git Bash / WSL / Bash only"
        menu_options[$option_num]="bash"
        ((option_num++))
    fi
    
    if [[ "$powershell_available" == true ]]; then
        echo "  $option_num) PowerShell only"
        menu_options[$option_num]="powershell"  
        ((option_num++))
    fi
    
    if [[ "$bash_available" == true && "$powershell_available" == true ]]; then
        echo "  $option_num) Both environments (recommended)"
        menu_options[$option_num]="both"
        ((option_num++))
    fi
    
    echo "  $option_num) Cancel installation"
    menu_options[$option_num]="cancel"
    
    echo ""
    echo -n "Enter your choice (1-$option_num): "
    read -r choice
    
    if [[ -z "${menu_options[$choice]}" ]]; then
        print_error "Invalid choice. Please try again."
        return 1
    fi
    
    echo "${menu_options[$choice]}"
}

# Main installation function
main() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║              GIT ALIASES CROSS-ENVIRONMENT INSTALLER           ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        print_status "Download Git from: https://git-scm.com/download/windows"
        exit 1
    fi
    
    # Show environment detection
    show_environment_detection
    
    # Show installation menu and get choice
    local install_choice
    while true; do
        install_choice=$(show_installation_menu)
        if [[ $? -eq 0 ]]; then
            break
        fi
        echo ""
    done
    
    echo ""
    print_status "Selected: $install_choice"
    echo ""
    
    # Handle the choice
    case "$install_choice" in
        "bash")
            install_to_bash
            ;;
        "powershell")
            install_to_powershell
            ;;
        "both")
            install_to_bash
            echo ""
            install_to_powershell
            ;;
        "cancel")
            print_status "Installation cancelled."
            exit 0
            ;;
        *)
            print_error "Unknown choice: $install_choice"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    INSTALLATION COMPLETE                      ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    
    # Check if GitHub CLI is available for the 'pr' alias
    if ! command -v gh &> /dev/null; then
        echo ""
        print_warning "GitHub CLI (gh) is not installed. The 'pr' alias won't work until you install it."
        print_status "Install GitHub CLI: https://cli.github.com/"
        print_status "For Windows: winget install --id GitHub.cli"
    fi
    
    echo ""
    print_success "Git aliases have been successfully installed! 🚀"
    print_status "You can now use short git commands like 'gst' for 'git status'"
    echo ""
}

# Run the main function
main "$@" 