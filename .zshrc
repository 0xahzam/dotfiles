# Path configuration
typeset -U path
path=(
  /opt/homebrew/bin
  /usr/local/bin
  $HOME/.local/bin      # uv
  $HOME/.bun/bin        # bun
  $HOME/.cargo/bin      # rust
  $path
)

# Environment variables
export GPG_TTY=$(tty)
export ZSH="$HOME/.oh-my-zsh"
export BUN_INSTALL="$HOME/.bun"

# Oh-My-Zsh configuration
ZSH_THEME="simple"
plugins=(git zsh-autosuggestions fast-syntax-highlighting)

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# Bun completion
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

export MANPAGER="less -R --use-color -Dd+r -Du+b"