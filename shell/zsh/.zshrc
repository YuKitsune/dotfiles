# Aliases
source ~/.aliases.zsh
[ -f ~/.aliases.private.zsh ] && source ~/.aliases.private.zsh

# Functions
source ~/.functions.zsh
[ -f ~/.functions.private.zsh ] && source ~/.functions.private.zsh

# Environment Variables
export REPOS=$HOME/Code
export DOTFILES=$REPOS/github.com/YuKitsune/dotfiles
export PROFILE=$(env $DOTFILES/.env PROFILE)

export XDG_CONFIG_HOME="$HOME/.config/"

[ -f ~/.environment.zsh ] && source ~/.environment.zsh

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Plugins
source $HOME/.plug.zsh
plugin "https://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions.zsh"
plugin "https://github.com/zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting.zsh"

# Case-insensitive completeions
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Updated wordchars
# What's different?
# - Removed `/`
# Default: *?_-.[]~=/&;!#$%^(){}<>
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Preferred editor for local and remote sessions
export EDITOR="nvim"

# Use OpenSSH installed from Brew instead of the built-in one
export PATH=$(brew --prefix openssh)/bin:$PATH

# Link to .NET tools
export PATH="$PATH:$HOME/.dotnet/tools"

# Configure zoxide to use cd prefix
eval "$(zoxide init --cmd cd zsh)"

# Add fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Configure direnv
eval "$(direnv hook zsh)"

# Load oh-my-posh
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $DOTFILES/config/oh-my-posh.toml)"
fi
# Cargo
export PATH="$HOME/.cargo/bin:$PATH"