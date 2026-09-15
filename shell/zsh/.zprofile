# Environment Variables
export REPOS=$HOME/Code
export DOTFILES=$REPOS/github.com/YuKitsune/dotfiles
export DOTFILES_PROFILE=$(env $DOTFILES/.env PROFILE)
export XDG_CONFIG_HOME="$HOME/.config/"

# Local Environment Variables (not synced)
[ -f ~/.environment.zsh ] && source ~/.environment.zsh

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Preferred editor
export EDITOR="nvim"

# Use OpenSSH installed from Brew instead of the built-in one
export PATH=$(brew --prefix openssh)/bin:$PATH

# Prefer Microsoft-installed .NET over Homebrew's (Homebrew dotnet is kept as a
# dependency for PowerShell, but the official SDK should take precedence)
export PATH="/usr/local/share/dotnet:$PATH"

# Link to .NET tools
export PATH="$PATH:$HOME/.dotnet/tools"

# Cargo
export PATH="$HOME/.cargo/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
