# General
alias reload="source ~/.zshrc"
alias c="clear"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias t="task"

# Enable ls colors
alias l="exa --oneline --icons"
alias diff="diff-so-fancy"
alias du="dua-cli"

# nvim
alias vi="nvim"
alias vim="nvim"

# kubectl
alias k="kubectl"

alias ka="kubectl apply"
alias kd="kubectl delete"

alias kgp="kubectl get pods"
alias kdp="kubectl describe pod"
alias kl="kubectl logs"

alias kpv="kubectl get pv"
alias kpvc="kubectl get pvc"

# docker
alias d="docker"
alias dp="docker ps"
alias dq="docker ps --format \"{{.Names}}\" | gum choose --no-limit | xargs docker stop"
alias ld="lazydocker"

# git
alias g="git"
alias gl="git log"
alias gs="git status"

alias gc="git checkout"
alias ga="git add ."
alias gcm="git commit -m"
alias gd="git pull" # "pull Down"
alias gu="git push" # "push Up"

alias yeet="git add . && git commit -m 'yeet' && git push"

alias lg="lazygit"
