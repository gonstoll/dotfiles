autoload -U colors && colors

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

LANG=en_US.UTF-8

# Configs
source $ZDOTDIR/config/options.zsh
source $ZDOTDIR/config/aliases.zsh
if [[ -f $ZDOTDIR/config/custom.zsh ]]; then
  source $ZDOTDIR/config/custom.zsh
fi

# tmux messes up LS colors, reset to default
[[ ! -z $TMUX ]] && unset LS_COLORS

# Completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

# History
HISTFILE=$ZDOTDIR/.zsh_history
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

source $HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config/zsh//.p10k.zsh.
if [[ -f $ZDOTDIR/.p10k.zsh ]]; then
  source $ZDOTDIR/.p10k.zsh
fi

# Load bun
if [[ -s "$HOME/.config/bun/_bun" ]]; then
  source "$HOME/.config/bun/_bun"
fi

# Load rust
if [[ -s "$XDG_CONFIG_HOME/rust/.cargo/env" ]]; then
  source "$XDG_CONFIG_HOME/rust/.cargo/env"
fi

source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zoxide
eval "$(zoxide init zsh)"

# Fzf
source $ZDOTDIR/fzf
source <(fzf --zsh)

# Edit command line in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# Use fzf for history search
# bindkey '^R' fzf-history-widget

# Loading syntax highlighting last on purpose
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load nvm if present
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi

# Functions
source $ZDOTDIR/functions
