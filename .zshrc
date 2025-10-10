# =============================================================
# .zshrc
# =============================================================

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker
  npm
  node
)

source $ZSH/oh-my-zsh.sh

# $ZSH_CUSTOM/aliases.zsh

# This is for homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# This is to run sdkman
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"