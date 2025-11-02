# Environment variables
export GPG_TTY=$(tty)
export ZSH="$HOME/.oh-my-zsh"


# Oh-My-Zsh configuration
ZSH_THEME="simple"
plugins=(git zsh-autosuggestions fast-syntax-highlighting)

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

export MANPAGER="less -R --use-color -Dd+r -Du+b"

