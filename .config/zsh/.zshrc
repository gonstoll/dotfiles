autoload -U colors && colors

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSHRC_PATH="$(readlink -f - $HOME/.config/zsh)/.zshrc" # get the path of the .zshrc symlink
ZSH_PATH=$(dirname $ZSHRC_PATH) # get the path of the zsh folder
LANG=en_US.UTF-8

# Configs
source $ZSH_PATH/config/options.zsh
source $ZSH_PATH/config/aliases.zsh
if [[ -f $ZSH_PATH/config/custom.zsh ]]; then
  source $ZSH_PATH/config/custom.zsh
fi

# tmux messes up LS colors, reset to default
[[ ! -z $TMUX ]] && unset LS_COLORS

# Completions
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

# History
HISTFILE=$ZDOTDIR/.histfile
HISTSIZE=1100000000
SAVEHIST=1000000000
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# Disable the highlighting of text pasted into the terminal.
zle_highlight=('paste:none')

autoload -U +X compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Vi mode
bindkey -v

# set 1ms timeout for Esc press so we can switch
# between vi "normal" and "command" modes faster
export KEYTIMEOUT=1

# Use vim keys in tab complete menu (2nd tab press):
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# By default backspace (^?) is bound to `vi-backward-delete-char`
# we want it to have the same bahvior as vim/nvim (i.e. backspace=del)
# without the below we will get stuck unable to backspace after Esc-k-A
bindkey -v '^?' backward-delete-char

# Better searching in vi command mode
bindkey -M vicmd '/' history-incremental-search-forward
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey -M viins '^r' history-incremental-search-backward

# Start tmux-sessionizer:
# Terminal binds cmd+s to Ctrl-f+s. This binds Ctrl-f+s to `s<CR>` which is an
# alias for tmux-sessionizer)
bindkey -s "^FS" "s\n"

source $ZSH_PATH/plugins/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config/zsh//.p10k.zsh.
[[ ! -f $ZSH_PATH/.p10k.zsh ]] || source $ZSH_PATH/.p10k.zsh

# Variables
if [[ -n $SSH_CONNECTION ]]; then
  export VISUAL='vim'
  export EDITOR='vim'
  export GIT_EDITOR='vim'
else
  export EDITOR="$(which nvim)"
  export VISUAL="$EDITOR"
  export GIT_EDITOR="$EDITOR"
fi

if [[ -s "$HOME/.config/bun/_bun" ]]; then
  source "$HOME/.config/bun/_bun"
fi
export BUN_INSTALL="$HOME/.config/bun"
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.config/bin:$HOME/.config/tmux/bin:$PATH
export PATH="$BUN_INSTALL/bin:$PATH"

# Plugins
source $ZSH_PATH/plugins/fzf/fzf.zsh
source $ZSH_PATH/plugins/fzf-tab/fzf-tab.plugin.zsh
source $ZSH_PATH/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

# Zoxide
eval "$(zoxide init zsh)"

# Tmux
export T_FZF_BORDER_LABEL='tmux finder'
export FZF_TMUX_OPTS="-p 100%,100%"

# Fzf
source <(fzf --zsh)
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
function _fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# bun completions
[ -s "$HOME/.config/bun/_bun" ] && source "$HOME/.config/bun/_bun"

# rust
export RUSTUP_HOME="$HOME/.config/rust/.rustup"
export CARGO_HOME="$HOME/.config/rust/.cargo"

# Eza (better ls)
alias ls="eza --icons=always"

# Bat
export BAT_CONFIG_PATH="$HOME/.config/bat/bat.conf"

# Yazi (file manager system)
# Use y to change the current directory when exiting yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Edit command line in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Use fzf for history search
# bindkey '^R' fzf-history-widget

export MANPAGER='nvim +Man!'

# Use fzf to view and focus on aerospace windows
function ff() {
  aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}

# Loading syntax highlighting last on purpose
source $ZSH_PATH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
