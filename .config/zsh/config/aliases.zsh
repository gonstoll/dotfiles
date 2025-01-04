# Fzf
alias fd="cd ~ && cd \$(find * -type d | fzf)" # cd into a directory

# Lazygit
alias lg="lazygit"
alias g="git"

# Neovim
alias vim="nvim"

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
