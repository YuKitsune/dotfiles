tap "octopusdeploy/taps" 
tap "hashicorp/tap"
brew "octopusdeploy/taps/octopus-cli"
cask "1password-cli"
# Command-line shell and scripting language
brew "powershell", link: false
cask "slack"
cask "meetingbar"
cask "docker-desktop"
# Desktop virtualization software
cask "parallels"
vscode "octopusdeploy.vscode-octopusdeploy"
vscode "hashicorp.hcl"

# Terraform
brew "hashicorp/tap/terraform", trusted: true

