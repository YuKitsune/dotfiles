#!/usr/bin/env bash

set -e

source $PWD/scripts/utils.sh

# Set up a trap to catch the interrupt signal and exit the script
trap 'echo "SIGINT detected. Exiting..."; exit 1' SIGINT

function install_cli_tools() {
    echo "Installing CLI tools..."

    # Update package lists
    sudo apt-get update

    # APT packages (CLI tools)
    sudo apt-get install -y \
        ansible \
        bash \
        bat \
        curl \
        direnv \
        fd-find \
        fontforge \
        fzf \
        git \
        httpie \
        hugo \
        hyperfine \
        jq \
        libfido2-dev \
        llvm \
        neovim \
        nodejs \
        npm \
        openssh-client \
        ripgrep \
        tmux \
        watch \
        wget \
        zsh

    sudo apt-get install -y python3 python3-pip
    sudo apt-get install -y golang-go
    sudo apt-get install -y lazygit
    
    sudo snap install yq
    sudo snap install --classic go-task
    sudo snap install --classic kubectl
    sudo snap install --classic helm
    sudo snap install minikube
    sudo snap install delve --classic

    echo "CLI tools installed"

    # Change default shell to zsh (verify installation first)
    if ! command -v zsh &> /dev/null; then
        echo "Error: zsh installation failed or not in PATH. Cannot change default shell."
        return 1
    fi

    if [ "$SHELL" != "$(which zsh)" ]; then
        echo "Changing default shell to zsh..."
        chsh -s $(which zsh)
        echo "Default shell changed to zsh. You'll need to log out and back in for this to take effect."
    else
        echo "zsh is already the default shell"
    fi
}

function install_rust() {
    if command -v rustc &> /dev/null; then
        echo "Rust is already installed"
        return
    fi

    # rustup is recommended over apt
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
}

function install_gh() {
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y gh
}

function install_npm_packages() {
    if ! command -v npm &> /dev/null; then
        echo "npm is not installed. Please install 'cli tools' first."
        return 1
    fi

    sudo npm install -g diff-so-fancy
}

function install_cargo_packages() {
    if ! command -v cargo &> /dev/null; then
        echo "cargo is not installed. Please install 'rust' first."
        return 1
    fi

    cargo install zoxide --locked
}

function install_brew_packages() {
    if ! command -v brew &> /dev/null; then
        echo "brew is not installed. Please run bootstrap-ubuntu.sh first."
        return 1
    fi

    brew install lazydocker
}

function install_ohmyposh() {
    curl -s https://ohmyposh.dev/install.sh | bash -s
}

function install_gui_apps() {
    echo "Installing GUI applications..."

    # Flatpak setup
    if ! command -v flatpak &> /dev/null; then
        echo "Installing Flatpak..."
        sudo apt-get update
        sudo apt-get install -y flatpak
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    flatpak install -y flathub com.discordapp.Discord
    flatpak install -y flathub md.obsidian.Obsidian
    flatpak install -y flathub org.signal.Signal
    flatpak install -y flathub com.spotify.Client
    flatpak install -y flathub com.visualstudio.code
    flatpak install -y flathub org.videolan.VLC
    flatpak install -y flathub com.yubico.yubioath

    echo "GUI applications installed successfully"
}

function install_docker() {
    echo "Installing Docker..."

    if ! command -v docker &> /dev/null; then
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
        echo "Docker installed. You may need to log out and back in for group permissions to take effect."
    else
        echo "Docker is already installed"
    fi
}

function install_vscode_extensions() {
    echo "Installing VSCode extensions..."

    # Check if VSCode is installed (either via apt/snap or flatpak)
    if command -v code &> /dev/null; then
        CODE_CMD="code"
    elif command -v flatpak &> /dev/null && flatpak list | grep -q "com.visualstudio.code"; then
        CODE_CMD="flatpak run com.visualstudio.code"
    else
        echo "VSCode is not installed. Skipping extension installation."
        return
    fi

    $CODE_CMD --install-extension anthropic.claude-code
    $CODE_CMD --install-extension bradlc.vscode-tailwindcss
    $CODE_CMD --install-extension davidanson.vscode-markdownlint
    $CODE_CMD --install-extension dbaeumer.vscode-eslint
    $CODE_CMD --install-extension docker.docker
    $CODE_CMD --install-extension eamodio.gitlens
    $CODE_CMD --install-extension editorconfig.editorconfig
    $CODE_CMD --install-extension esbenp.prettier-vscode
    $CODE_CMD --install-extension golang.go
    $CODE_CMD --install-extension heybourn.headwind
    $CODE_CMD --install-extension maptz.camelcasenavigation
    $CODE_CMD --install-extension mateocerquetella.xcode-12-theme
    $CODE_CMD --install-extension mikestead.dotenv
    $CODE_CMD --install-extension ms-azuretools.vscode-containers
    $CODE_CMD --install-extension ms-azuretools.vscode-docker
    $CODE_CMD --install-extension rust-lang.rust-analyzer
    $CODE_CMD --install-extension tamasfe.even-better-toml
    $CODE_CMD --install-extension tobermory.es6-string-html
    $CODE_CMD --install-extension vscode-icons-team.vscode-icons
    $CODE_CMD --install-extension wayou.vscode-todo-highlight

    echo "VSCode extensions installed successfully"
}

echo "🤔 Which package groups do you want to install?"
groups=$(gum choose --no-limit "cli tools" "rust" "gh" "npm packages" "cargo packages" "brew packages" "oh-my-posh" "gui apps" "docker" "vscode extensions")

element_exists_in_array "cli tools" ${groups[*]}
if [ $? -eq 0 ]; then
    install_cli_tools
fi

element_exists_in_array "rust" ${groups[*]}
if [ $? -eq 0 ]; then
    install_rust
fi

element_exists_in_array "gh" ${groups[*]}
if [ $? -eq 0 ]; then
    install_gh
fi

element_exists_in_array "npm packages" ${groups[*]}
if [ $? -eq 0 ]; then
    install_npm_packages
fi

element_exists_in_array "cargo packages" ${groups[*]}
if [ $? -eq 0 ]; then
    install_cargo_packages
fi

element_exists_in_array "brew packages" ${groups[*]}
if [ $? -eq 0 ]; then
    install_brew_packages
fi

element_exists_in_array "oh-my-posh" ${groups[*]}
if [ $? -eq 0 ]; then
    install_ohmyposh
fi

element_exists_in_array "gui apps" ${groups[*]}
if [ $? -eq 0 ]; then
    install_gui_apps
fi

element_exists_in_array "docker" ${groups[*]}
if [ $? -eq 0 ]; then
    install_docker
fi

element_exists_in_array "vscode extensions" ${groups[*]}
if [ $? -eq 0 ]; then
    install_vscode_extensions
fi

echo ""
echo "Package installation complete!"
echo ""
echo "Note: Some packages may require a restart or re-login to work properly."
echo "- Docker: Log out and back in for group permissions"
echo "- Flatpak apps: May need to add /var/lib/flatpak/exports/bin to PATH"
