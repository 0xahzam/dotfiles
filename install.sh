#!/bin/bash

# Symlink configs
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/init.lua ~/.config/nvim/init.lua

echo "Dotfiles linked"
