#!/bin/sh

echo ">>> Installing runtime dependencies"

# Luarocks
luarocks install --server=https://luarocks.org/dev luaformatter

# NPM global packages
npm install -g depcheck eslint prettier prettier-plugin-tailwindss typescript typescript-language-server vscode-langservers-extracted

# Bun
curl -fsSL https://bun.sh/install | bash

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
~/.config/tmux/plugins/tpm/bin/install_plugins

# Wezterm terminfo file
tempfile=$(mktemp) \
  && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo \
  && tic -x -o ~/.terminfo $tempfile \
  && rm $tempfile
