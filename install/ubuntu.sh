#!/bin/bash

set -e

echo "Setting up Ubuntu..."

# Update package list
echo "Updating package list..."
sudo apt update

# Add Neovim PPA
if ! grep -q "neovim-ppa/unstable" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
    echo "Adding Neovim PPA..."
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    sudo apt update
else
    echo "Neovim PPA already added"
fi

# Install CLI tools
echo "Installing CLI tools..."
apt_tools=(zsh neovim htop btop ripgrep jq curl git build-essential gcc clang unzip)
for tool in "${apt_tools[@]}"; do
    if ! dpkg -l | grep -q "^ii  $tool "; then
        sudo apt install -y "$tool"
    else
        echo "$tool already installed"
    fi
done

# Install Node via NodeSource
if ! command -v node &> /dev/null; then
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
else
    echo "Node.js already installed"
fi

# Install VS Code
if ! command -v code &> /dev/null; then
    echo "Installing VSCode..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt update
    sudo apt install -y code
else
    echo "VSCode already installed"
fi

# Install Kitty
if ! command -v kitty &> /dev/null; then
    echo "Installing Kitty..."
    sudo apt install -y kitty
else
    echo "Kitty already installed"
fi

# Install Zed
if [ ! -f "$HOME/.local/bin/zed" ]; then
    echo "Installing Zed..."
    curl -f https://zed.dev/install.sh | sh
else
    echo "Zed already installed"
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed"
fi

# Install Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
plugins=(zsh-autosuggestions fast-syntax-highlighting)
repos=(zsh-users/zsh-autosuggestions zdharma-continuum/fast-syntax-highlighting)

for i in "${!plugins[@]}"; do
    plugin_dir="$ZSH_CUSTOM/plugins/${plugins[$i]}"
    if [ ! -d "$plugin_dir" ]; then
        echo "Installing ${plugins[$i]}..."
        git clone "https://github.com/${repos[$i]}.git" "$plugin_dir"
    else
        echo "${plugins[$i]} already installed"
    fi
done

# Install bun
if [ ! -f "$HOME/.bun/bin/bun" ]; then
    echo "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
else
    echo "bun already installed"
fi

# Install yarn
if ! command -v yarn &> /dev/null; then
    echo "Installing yarn..."
    sudo npm install -g yarn
else
    echo "yarn already installed"
fi

# Install uv
if [ ! -f "$HOME/.local/bin/uv" ]; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "uv already installed"
fi

export PATH="$HOME/.local/bin:$PATH"

# Install Python via uv
if ! uv python list | grep -q "cpython"; then
    echo "Installing Python..."
    uv python install
else
    echo "Python already installed"
fi

# Install rustup
if [ ! -f "$HOME/.cargo/bin/rustup" ]; then
    echo "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
    echo "rustup already installed"
fi

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    sudo chsh -s "$(which zsh)"
else
    echo "zsh already default shell"
fi

# Symlink dotfiles
echo "Symlinking dotfiles..."
DOTFILES_DIR="$HOME/dotfiles"
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
mkdir -p "$HOME/.config/nvim"
ln -sf "$DOTFILES_DIR/init.lua" "$HOME/.config/nvim/init.lua"

echo "Setup complete. Restart terminal."