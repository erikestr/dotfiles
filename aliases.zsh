# ~/.oh-my-zsh/custom/aliases.zsh

# ============================================================
# Aliases
# ============================================================

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias dev='cd ~/dev'
alias c='clear'
alias h='history'
alias j='jobs -l'
alias l='ls -lah'
alias ll='ls -lah'
alias ls='ls --color=auto'
alias v='nvim'

# git
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gcb='git checkout -b'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate --all'
alias gcl='git clone'
alias gmt='git mergetool'
alias gr='git remote -v'
alias gss='git stash'
alias gsp='git stash pop'
alias gsa='git stash apply'
alias gbr='git branch -r'
alias gbl='git blame'
alias gfa='git fetch --all --prune'
alias gff='git fetch --force'
alias gpr='git pull --rebase'
alias gcp='git cherry-pick'
alias gundo='git reset --soft HEAD~1'
alias gcount='git rev-list --count HEAD'

