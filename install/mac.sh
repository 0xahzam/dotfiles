#!/bin/bash

set -e

echo "Setting up Mac..."

# Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew already installed"
fi

# Install CLI tools
echo "Installing CLI tools..."
brew_tools=(zsh neovim htop btop ripgrep jq curl git node)
for tool in "${brew_tools[@]}"; do
    if ! brew list "$tool" &> /dev/null; then
        brew install "$tool"
    else
        echo "$tool already installed"
    fi
done

# Install rustup
if ! command -v rustup &> /dev/null; then
    echo "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
    echo "rustup already installed"
fi

# Install GUI apps
echo "Installing applications..."
cask_apps=(visual-studio-code zed kitty)
for app in "${cask_apps[@]}"; do
    if ! brew list --cask "$app" &> /dev/null; then
        brew install --cask "$app"
    else
        echo "$app already installed"
    fi
done

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
if ! command -v bun &> /dev/null; then
    echo "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
else
    echo "bun already installed"
fi

# Install yarn
if ! command -v yarn &> /dev/null; then
    echo "Installing yarn..."
    npm install -g yarn
else
    echo "yarn already installed"
fi

# Install uv
if ! command -v uv &> /dev/null; then
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

# Change default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
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