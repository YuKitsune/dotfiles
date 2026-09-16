# General
alias reload="source ~/.zprofile && source ~/.zshrc"
alias c="clear"
alias x="exit"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias reset_bluetooth="sudo pkill bluetoothd"

# plz
alias t="plz"

# nvim
alias vi="nvim"
alias vim="nvim"

# kubectl
alias k="kubectl"

# docker
alias d="docker"
alias ld="lazydocker"
alias dc="docker compose"

# Apple Container
alias cc="container-compose"

# git
alias g='git'
alias ga='git add'
alias gl='git log'

alias gs='git switch'
alias gco='git checkout'
alias gcob='git checkout -b'

alias ggb='git rev-parse --abbrev-ref HEAD'
alias grb='git branch --move'

alias gc='git commit'
alias gcm='git commit --message'

alias gf='git fetch'
alias gps='git push'
alias gpl="git pull"

alias lg="lazygit"

# github
alias gpc="gh pr create"
alias gpcw="gh pr create --web"
alias gpv="gh pr view"
alias gpvw="gh pr view --web"
alias grv="gh repo view"
alias grvw="gh repo view --web"
alias gam="gh pr merge --auto --squash"
