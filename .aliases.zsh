# General
alias reload="source ~/.zshrc"
alias c="clear"

# Enable ls colors
alias l="ls -lah --color"
alias diff="diff --color"

# nvims
alias vi="nvim"
alias vim="nvim"

# kubectl
alias k="kubectl"
alias kgp="kubectl get pods -A"
alias kdp="kubectl describe pod"
alias kl="kubectl logs"

# docker
alias dp="docker ps"
alias ds="docker start"
alias dq="docker ps --format \"{{.Names}}\" | gum choose --no-limit | xargs docker stop"
alias ld="lazydocker"

# git
alias g="git"
alias gc="git checkout"
alias ga="git add ."
alias gcm="git commit -m"
alias yeet="git add . && git commit -m 'yeet' && git push"
alias lg="lazygit"
