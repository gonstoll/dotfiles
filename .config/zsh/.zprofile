# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

eval "$(/opt/homebrew/bin/brew shellenv)"

# PATH
export PATH="$HOME/.local/bin:$PATH" # Local scripts
export PATH="$XDG_CONFIG_HOME/bin:$PATH" # Custom scripts
export PATH="$XDG_CONFIG_HOME/tmux/bin:$PATH" # Tmux scripts
export PATH="$XDG_CONFIG_HOME/rust/.cargo/bin:$PATH" # Cargo
export PATH="$XDG_CONFIG_HOME/go/bin:$PATH" # Go binaries

# Postgresql
export PATH="$HOMEBREW_PREFIX/opt/postgresql@17/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.config/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Brew bundle file
export HOMEBREW_BUNDLE_FILE="$HOME/.dotfiles/Brewfile"

# Man pages
export MANPAGER='nvim +Man!'

# Bat
export BAT_CONFIG_PATH="$HOME/.config/bat/bat.conf"

# Fzf
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_DEFAULT_OPTS='--style=minimal --no-bold --no-unicode --height=100% --margin=10% --bind ctrl-d:preview-down,ctrl-u:preview-up'
export FZF_CTRL_R_OPTS="--margin=0 --height=50% --color=bw"
export FZF_CTRL_T_OPTS="--height=50% --preview '$show_file_or_dir_preview'"

# nvm
export NVM_DIR="$XDG_CONFIG_HOME/nvm"

# Don't let Ghostty mess up with the cursor.
export GHOSTTY_SHELL_INTEGRATION_NO_CURSOR=1

# Set 1ms timeout for Esc press so we can switch
# between vi "normal" and "command" modes faster
export KEYTIMEOUT=1

export EDITOR="nvim"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"
export CURSOR_CONFIG_DIR="$XDG_CONFIG_HOME/cursor/cli-config.json"
