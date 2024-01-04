# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

ZSHRC_PATH="$(readlink $HOME/.config/zsh)/.zshrc" # get the path of the .zshrc symlink
ZSH_PATH=$(dirname $ZSHRC_PATH) # get the path of the zsh folder

# custom zsh configurations
if [[ -f $ZSH_PATH/config/custom.zsh ]]; then
  source $ZSH_PATH/config/custom.zsh
fi

# History
HISTSIZE=110000
SAVEHIST=100000
HISTFILE=$ZDOTDIR/.histfile

zstyle :compinstall $ZDOTDIR/.zshrc
autoload -Uz compinit
compinit

# Powerlevel10k
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh//.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $ZSH_PATH/plugins/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.config/zsh//.p10k.zsh.
[[ ! -f $ZSH_PATH/.p10k.zsh ]] || source $ZSH_PATH/.p10k.zsh

# Variables
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export TERM=wezterm
export TERMINFO="$HOME/.terminfo/"

if [[ -s "$HOME/.config/bun/_bun" ]]; then
  source "$HOME/.config/bun/_bun"
fi
export BUN_INSTALL="$HOME/.config/bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
export PATH=$HOME/dotfiles/bin:$PATH

# Plugins
source $ZSH_PATH/plugins/fzf/fzf.zsh
source $ZSH_PATH/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source $ZSH_PATH/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $ZSH_PATH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZSH_PATH/plugins/iterm2_shell_integration/iterm2_shell_integration.zsh

# Configs
source $ZSH_PATH/config/options.zsh
source $ZSH_PATH/config/aliases.zsh

# Zoxide
eval "$(zoxide init zsh)"

# Tmux
export T_FZF_BORDER_LABEL='tmux finder'

# zsh-vi-mode
export ZVM_CURSOR_STYLE_ENABLED=false
export ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
export ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK

# bun completions
[ -s "$HOME/.config/bun/_bun" ] && source "$HOME/.config/bun/_bun"

# rust
export RUSTUP_HOME="$HOME/.config/rust/.rustup"
export CARGO_HOME="$HOME/.config/rust/.cargo"
