# Fzf
alias fd="cd \$(find . -type d | fzf)" # cd into a directory

# Git
alias lg="lazygit"
alias g="git"

# Neovim
alias vim="nvim"
alias vi="nvim"

# Navigation
alias ..="cd .. && cd .."

# MySQL
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin

# Tmux
alias s="tmux-sessionizer"
alias tn="tmux new -s $(pwd | sed 's/.*\///g')"

# Eza (better ls)
alias ls="eza --icons=always"

# Docker
alias ld="lazydocker"
