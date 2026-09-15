# Aliases
source ~/.aliases.zsh
[ -f ~/.aliases.private.zsh ] && source ~/.aliases.private.zsh

# Functions
source ~/.functions.zsh
[ -f ~/.functions.private.zsh ] && source ~/.functions.private.zsh

# ZSH Plugins
source $HOME/.plug.zsh
plugin "https://github.com/zsh-users/zsh-autosuggestions" "zsh-autosuggestions.zsh"
plugin "https://github.com/zsh-users/zsh-syntax-highlighting" "zsh-syntax-highlighting.zsh"

# Case-insensitive completeions
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Updated wordchars
# Removed `/`
# Default: *?_-.[]~=/&;!#$%^(){}<>
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Configure zoxide to use cd prefix
eval "$(zoxide init --cmd cd zsh)"

# Add fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Configure direnv
eval "$(direnv hook zsh)"

# CTRL-X to open command buffer in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x' edit-command-line

# Bind CTRL-Z to undo
bindkey '^Z' undo

# Load oh-my-posh
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $DOTFILES/config/oh-my-posh.toml)"
fi

if [ "$TMUX" = "" ] && [ "$TERM_PROGRAM" = "ghostty" ]; then
  sesh picker
fi

if [ "$TMUX" = "" ] && [ -n "$WT_SESSION" ]; then
  tmux new-session -A -s wsl
fi

# Node Version Manager (nvm)
export NVM_DIR="$HOME/.config//nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/eoinmotherway/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit
# End of Docker CLI completions
