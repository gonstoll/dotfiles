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

# Completions
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

# Show completion suggestions in a menu
zstyle ':completion:*' menu select
zstyle ':completion:*' auto-description '— %d'
zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' format '» %B%d%b (%B%F{green}%n%f%b)'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' max-errors 2 numeric
zstyle ':completion:*' original true

# History
HISTFILE=$ZDOTDIR/.histfile
HISTSIZE=1100000000
SAVEHIST=1000000000
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey -s "^FS" "s\n" # Start tmux-sessionizer. Make sure "s" is an alias that executes "tmux-sessionizer"

# Disable the highlighting of text pasted into the terminal.
zle_highlight=('paste:none')

autoload -U compinit; compinit
autoload -U colors; colors

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

export TERM="wezterm"
export TERMINFO="$HOME/.terminfo/"

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
source $ZSH_PATH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

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
