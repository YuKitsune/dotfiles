# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $HOME/.plug.zsh

# Plugins
plugin "https://github.com/romkatv/powerlevel10k" "powerlevel10k.zsh-theme"
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

# Aliases
## Create the private alias file if it doesn't exist
if [ ! -e "~/.aliases.private.zsh" ]
then
    touch ~/.aliases.private.zsh
fi

source ~/.aliases.zsh
source ~/.aliases.private.zsh

# Functions
## Create the private functions file if it doesn't exist
if [ ! -e "~/.functions.private.zsh" ]
then
    touch ~/.functions.private.zsh
fi

source ~/.functions.zsh
source ~/.functions.private.zsh

# Environment Variables
if [ ! -e "~/.environment.zsh" ]
then
    touch ~/.environment.zsh
fi

source ~/.environment.zsh

# Use OpenSSH installed from Brew instead of the built-in one
export PATH=$(brew --prefix openssh)/bin:$PATH

# Link to .NET tools
export PATH="$PATH:$HOME/.dotnet/tools"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Add fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Configure zoxide to use cd prefix
eval "$(zoxide init --cmd cd zsh)"

# dotfile environment variables
export REPOS=$HOME/Developer
export DOTFILES=$REPOS/github.com/YuKitsune/dotfiles
export PROFILE=$(env $DOTFILES/.env PROFILE)

export XDG_CONFIG_HOME="$HOME/.config/"
