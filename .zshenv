# XDG base directories.
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"

# PATH
export PATH=$HOME/.local/bin:$PATH # Local scripts
export PATH=$HOME/.config/bin:$PATH # Custom scripts
export PATH=$HOME/.config/tmux/bin:$PATH # Tmux scripts

# zsh configuration.
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Man pages
export MANPAGER='nvim +Man!'

# Set up neovim as the default editor.
export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"
export GIT_EDITOR="$EDITOR"

# Don't let Ghostty mess up with the cursor.
export GHOSTTY_SHELL_INTEGRATION_NO_CURSOR=1

# Rust
export RUSTUP_HOME="$HOME/.config/rust/.rustup"
export CARGO_HOME="$HOME/.config/rust/.cargo"

# Bun
export BUN_INSTALL="$HOME/.config/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Bat
export BAT_CONFIG_PATH="$HOME/.config/bat/bat.conf"

# Fzf
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"

# Set 1ms timeout for Esc press so we can switch
# between vi "normal" and "command" modes faster
export KEYTIMEOUT=1