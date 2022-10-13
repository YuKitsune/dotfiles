#!/usr/bin/env bash

command="$1"

if [ $command != "install" ] && [ $command != "uninstall" ]
then
    echo "unsupported argument: '$command'"
    exit 1
fi

# Useful commands
brew $command wget
brew $command fortune
brew $command cowsay
brew $command lolcat
brew $command youtube-dl
brew $command watch
brew $command neofetch

# Broken, needs manual download
# brew $command dockutil
# Todo: Use curl
wget -P $HOME/Downloads https://github.com/kcrawford/dockutil/releases/download/3.0.2/dockutil-3.0.2.pkg
installer -pkg $HOME/Downloads/dockutil-3.0.2.pkg -target /

# Terminal
brew $command --cask hyper

# SDKs
brew $command go
brew $command --cask dotnet-sdk
brew $command node
brew $command python
brew $command hugo

# Developer Tools
brew $command git
brew $command font-jetbrains-mono-nerd-font
brew $command nvim
brew $command lazygit
brew $command fork
brew $command --cask goland
brew $command --cask rider
brew $command --cask webstorm
brew $command --cask clion
brew $command --cask datagrip
brew $command --cask visual-studio-code
brew $command --cask firefox

# DevOps
brew $command act
brew $command gh
brew $command docker
brew $command lazydocker
brew $command minikube
brew $command kubernetes-cli
brew $command helm

# Other programs

# Utilities
brew $command stats
brew $command --cask rectangle
brew $command --cask onyx
brew $command --cask lulu
brew $command --cask mos
brew $command --cask bitwarden
brew $command --cask parallels

# Media
brew $command --cask spotify
brew $command --cask discord

brew $command --cask affinity-photo
brew $command --cask affinity-designer
brew $command --cask ableton-live-suite
