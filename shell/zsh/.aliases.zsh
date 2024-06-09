# General
alias reload="source ~/.zshrc"
alias c="clear"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias reset_bluetooth="sudo pkill bluetoothd"

# Taskfiles
alias t="task"
alias tl="task --list --json | jq -r '.tasks[].name' | gum choose | xargs task"

# Core commands
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
alias dc="docker compose"

# git
alias g='git'
alias ga='git add'
alias gl='git log'

alias gco='git checkout'
alias gcb='git checkout -b'

alias ggb='git rev-parse --abbrev-ref HEAD'

alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gclean='git clean --interactive -d'
alias gcl='git clone --recurse-submodules'

alias gc='git commit'
alias gcm='git commit --message'

alias gf='git fetch'
alias gps='git push'
alias gpl="git pull"

alias yeet="git add . && git commit -m 'yeet' && git push"
alias lg="lazygit"

# github
alias gpc="gh pr create"
alias gpcw="gh pr create --web"
alias gpv="gh pr view"
alias gpvw="gh pr view --web"
alias grv="gh repo view"
alias grvw="gh repo view --web"
alias grl="gh release list"
alias grc="gh release create"
