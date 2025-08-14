# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is YuKitsune's cross-platform dotfiles repository that manages development environment configuration for macOS, Linux, and Windows.
The repository uses a task-based architecture with [Task](https://taskfile.dev) as the primary automation which is being migrated to [plz](https://plz.sh).

## Key Architecture

### Task-Based System

The repository is built around Taskfiles that handle different aspects of environment setup:

- **Root Taskfile.yaml**: Main orchestrator that includes platform-specific taskfiles
- **darwin/Taskfile.yaml**: macOS-specific tasks
- **windows/Taskfile.yaml**: Windows-specific tasks
- Platform detection via `{{OS}}` variable automatically includes the correct taskfile

### Configuration Management

- **Symlink-based**: Configuration files are symlinked from this repo to their target locations
- **symlinks.yaml**: Defines all symlink mappings (git, zsh, VS Code, tmux, nvim, etc.)
- **Profile-based**: Uses `.env` file with `PROFILE` variable (personal/work) to load different configurations

### Package Management

- **Homebrew on macOS**: Brewfiles primarily used to manage applications, fonts, and CLI tools
- **Custom package scripts**: Support for .pkg files and git repository installations where packages are not available via brew
- **winget on Windows**: Winget is primarily used to manage packages on Windows (via winget.json)

## Common Commands

### Initial Setup

```sh
# Bootstrap prerequisites (Xcode tools, Homebrew, Task, gum)
./bootstrap.sh

# Full environment setup
task apply
```

### Main Tasks

```sh
# List all available tasks
task --list

# Apply all configuration (packages + symlinks + system config)
task apply

# Create symlinks for config files
task create-symlinks

# Clone/update git repositories
task clone-repos

# Configure system settings (interactive)
task configure

# Import SSH keys from USB drive
task import-ssh-keys

# Dump current package state to repo
task dump
```

### Platform-Specific

```sh
# macOS: Install SF Mono NerdFont
task system:install-sfmono-fonts

# Windows: Remove bloatware (run before task apply)
task system:debloat
```

## Environment Variables

Key environment variables defined in shell configuration:

- `REPOS`: `$HOME/Code` - Base directory for code repositories
- `DOTFILES`: `$REPOS/github.com/YuKitsune/dotfiles` - This repository path
- `DOTFILES_PROFILE`: Loaded from `.env` file (personal/work)
- `XDG_CONFIG_HOME`: `$HOME/.config/` - Standard config directory

## Shell Configuration

Uses **zsh** with custom plugin manager (`.plug.zsh`):

- **Aliases**: Defined in `shell/zsh/.aliases.zsh`
- **Functions**: Defined in `shell/zsh/.functions.zsh`
- **Plugins**: zsh-autosuggestions and zsh-syntax-highlighting
- **Prompt**: Oh My Posh with custom theme
- **Terminal**: Ghostty terminal emulator

## Development Tools

- **Editor**: Primarily using VSCode and JetBrains IDEs for development, occasionally using Neovim with NVChad for terminal-based editing.
- **Git**: Custom global config and ignore files
- **Terminal multiplexer**: tmux with custom configuration
- **Package managers**: Homebrew (macOS), winget (Windows)
- **Shell enhancements**: zoxide (cd replacement), fzf (fuzzy finder), direnv

## File Organization

- `config/`: Application configuration files (symlinked to target locations)
- `darwin/`: macOS-specific scripts, Brewfiles, and packages
- `windows/`: Windows-specific scripts, configurations, and packages
- `shell/zsh/`: Shell configuration and custom plugin system
- `nvim/`: Neovim/NVChad custom configuration
- `scripts/`: Utility scripts for setup and maintenance

## Key Considerations

- Bootstrap process sets up prerequisites before main application
- Configuration is symlinked, not copied - changes in this repo immediately affect system
- Profile system allows different configurations for personal vs work machines
- All symlinks are backed up before creation to `$HOME/.dotfile_backup`
- SSH key management is handled via external USB drive import process
