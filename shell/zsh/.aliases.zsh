# General
alias reload="source ~/.zshrc"
alias c="clear"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias t="task"

alias l="exa --long --all --icons --no-user --git"
alias diff="diff-so-fancy"
alias du="dua-cli"
alias cat="bat"

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

alias gco="git checkout"
alias ga="git add"
alias gcm="git commit"
alias gpl="git pull"
alias gps="git push"

alias yeet="git add . && git commit -m 'yeet' && git push"

alias lg="lazygit"

# github
alias gpc="gh pr create"
alias gpcw="gh pr create --web"
alias gpv="gh pr view"
alias gpvw="gh pr view --web"
alias grl="gh release list"
alias grc="gh release create"
