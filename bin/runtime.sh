#!/bin/sh

echo "> Installing runtime dependencies"

# NPM global packages
npm install -g depcheck eslint prettier prettier-plugin-tailwindss typescript typescript-language-server vscode-langservers-extracted

# Bun
curl -fsSL https://bun.sh/install | bash

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
~/.config/tmux/plugins/tpm/bin/install_plugins
