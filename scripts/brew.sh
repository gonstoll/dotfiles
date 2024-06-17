#!/bin/sh

echo ">>> Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo ">>> Installing Homebrew depedencies"
brew install --cask iterm2

# Neovim
brew install neovim
brew install luarocks && luarocks install --server=https://luarocks.org/dev luaformatter
brew install efm-langserver
brew install tree-sitter
brew install ripgrep
brew install gnu-sed
brew install --cask font-sf-mono-nerd-font

# Git
brew install git
brew install lazygit
brew install gh

# Pnpm
brew install pnpm

# Runtime
brew install node
# brew tap oven-sh/bun # for macOS and Linux
# brew install bun

# Raycast
brew install --cask raycast

# Redis
brew install redis

# Terminal
brew install neofetch
brew install zoxide
brew install gum
brew install tmux
brew install fd fzf
brew install tree
brew install tldr
brew install jq
brew install orbstack
brew install tursodatabase/tap/turso
brew install eza
brew install bat
