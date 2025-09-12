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

Run the installation script in Git Bash:

```bash
./install-windows.sh
```

**Note**: This script is designed for bash environments (Git Bash, WSL). After installation, you can set Git Bash as your default terminal in VS Code for the best experience.

## Setting Git Bash as Default Terminal in VS Code

For Windows users, we recommend using Git Bash as your default terminal in VS Code to fully utilize these git aliases:

### Method 1: Via Command Palette (Recommended)

1. Open VS Code
2. Press `Ctrl+Shift+P` to open the Command Palette
3. Type "Terminal: Select Default Profile" and select it
4. Choose "Git Bash" from the list
5. Open a new terminal with `Ctrl+`` (backtick) - it will now use Git Bash

### Method 2: Via Settings

1. Open VS Code Settings (`Ctrl+,`)
2. Search for "terminal integrated shell"
3. Click "Edit in settings.json"
4. Add or update this setting:

   ```json
   {
     "terminal.integrated.defaultProfile.windows": "Git Bash"
   }
   ```

### Method 3: Manual Profile Configuration

If Git Bash doesn't appear in the list, you can manually configure it:

1. Open VS Code Settings (`Ctrl+,`)
2. Search for "terminal integrated profiles"
3. Click "Edit in settings.json"
4. Add this configuration:

   ```json
   {
     "terminal.integrated.profiles.windows": {
       "Git Bash": {
         "path": "C:\\Program Files\\Git\\bin\\bash.exe",
         "args": ["--login"]
       }
     },
     "terminal.integrated.defaultProfile.windows": "Git Bash"
   }
   ```

**Note**: Adjust the path if Git is installed in a different location.

## Troubleshooting

### Git Bash not found in VS Code

If Git Bash doesn't appear as an option:

1. Make sure Git for Windows is properly installed
2. Restart VS Code after installing Git
3. Check that Git Bash is located at: `C:\Program Files\Git\bin\bash.exe`
4. Use Method 3 above to manually configure the path

### Aliases not working

If the aliases don't work after installation:

1. Close and reopen your terminal
2. Or run: `source ~/.bashrc` (or `source ~/.bash_profile` depending on your config)
3. Make sure you're using Git Bash, not PowerShell or Command Prompt

## Requirements

- Git (obviously!)
- For the `pr` alias: [GitHub CLI](https://cli.github.com/) installed and configured
- macOS/Linux: Zsh or Bash shell
- Windows: Git Bash, WSL, or any bash-compatible environment

## Contributing

Feel free to suggest additional aliases that would improve git productivity. Create an issue or submit a pull request with your recommendations!
