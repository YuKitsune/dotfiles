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

# Use OpenSSH instead of the built-in one
export PATH=$(brew --prefix openssh)/bin:$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Check for any updates to the dotfiles
check-dotfile-updates

# lmao
neofetch
