# Git Alias

A collection of powerful git aliases designed to boost your productivity and streamline your git workflow :octocat:. These aliases transform lengthy git commands into short, memorable shortcuts, helping developers work more efficiently with version control.

## Why Use Git Aliases?

Git aliases :octocat: are custom shortcuts that save time and reduce typing when working with git commands. Instead of typing `git status`, you can simply type `gst`. These aliases are particularly valuable for:

- **Increased Productivity**: Reduce keystrokes by up to 70% on common git operations
- **Muscle Memory**: Short, consistent aliases become second nature quickly
- **Reduced Errors**: Less typing means fewer typos in critical git commands
- **Workflow Optimization**: Complex command sequences become simple one-liners

## Included Aliases

This collection includes carefully selected aliases for the most common git operations:

### Basic Operations

- `g` - git
- `gst` - git status
- `ga` - git add
- `gcm` - git commit -m
- `gc` - git checkout
- `gcb` - git checkout -b

### Remote Operations

- `gp` - git push
- `gl` - git pull
- `gpr` - git pull --rebase
- `gf` - git fetch
- `gfa` - git fetch --all
- `gclone` - git clone
- `gr` - git remote

### Branch Management

- `gbd` - git branch -D
- `gm` - git merge
- `grb` - git rebase
- `gcp` - git cherry-pick

### History & Information

- `glog` - git log .
- `gcl` - git config --list

### Advanced Operations

- `grs` - git reset --soft
- `grh` - git reset --hard
- `gstash` - git stash push -m

### Productivity Boosters

- `gpo` - git push origin -u (current branch)
- `pr` - Push current branch and create PR with GitHub CLI

## Installation

### macOS/Linux/Unix

Run the installation script:

```bash
./install-unix.sh
```

This script works for any Unix-based OS, including macOS, Linux, and WSL.

### Windows

Run the cross-environment installation script:

```bash
./install-windows.sh
```

**Features:**

- 🔍 **Auto-detects** available environments (Git Bash, WSL, PowerShell)
- 🎯 **Smart installation** to your preferred terminal(s)
- 🔄 **Cross-environment support** - use the same aliases in both Git Bash and PowerShell
- 📁 **Automatic profile management** - creates PowerShell profiles if needed

**Installation Options:**

1. **Git Bash/WSL only** - Traditional shell aliases
2. **PowerShell only** - PowerShell functions
3. **Both environments** (recommended) - Works everywhere!

## Requirements

- Git (obviously!)
- For the `pr` alias: [GitHub CLI](https://cli.github.com/) installed and configured
- macOS/Linux: Zsh or Bash shell
- Windows: Git Bash or WSL

## Contributing

Feel free to suggest additional aliases that would improve git productivity. Create an issue or submit a pull request with your recommendations!
