# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Powerlevel10k
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh//.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme

# POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

ZSHRC_PATH="$(readlink $HOME/.config/zsh)/.zshrc" # get the path of the .zshrc symlink
ZSH_PATH=$(dirname $ZSHRC_PATH) # get the path of the zsh folder

# To customize prompt, run `p10k configure` or edit ~/.config/zsh//.p10k.zsh.
[[ ! -f $ZSH_PATH/.p10k.zsh ]] || source $ZSH_PATH/.p10k.zsh

# Variables
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export TERM=xterm-256color
# export TERMINFO='/usr/share/terminfo/'

[ -s "$HOME/.config/bun/_bun" ] && source "$HOME/.config/bun/_bun"
export BUN_INSTALL="$HOME/.config/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Plugins
source $ZSH_PATH/plugins/z/z.sh
source $ZSH_PATH/plugins/fzf/fzf.zsh
source $ZSH_PATH/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source $ZSH_PATH/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $ZSH_PATH/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $ZSH_PATH/plugins/iterm2_shell_integration/iterm2_shell_integration.zsh

# Configs
source $ZSH_PATH/config/options.zsh
source $ZSH_PATH/config/aliases.zsh
[ -f $ZSH_PATH/config/custom.zsh ] && source $ZSH_PATH/config/custom.zsh # Custom zsh configurations

# History
HISTSIZE=110000
SAVEHIST=100000
HISTFILE=$ZDOTDIR/.histfile

zstyle :compinstall $ZDOTDIR/.zshrc
autoload -Uz compinit
compinit
