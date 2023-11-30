#!/bin/sh

echo "> Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "> Installing Homebrew depedencies"
brew install --cask iterm2

# Neovim
brew install neovim
brew install luarocks && luarocks install --server=https://luarocks.org/dev luaformatter
brew install efm-langserver
brew install tree-sitter
brew install ripgrep
brew install gnu-sed

# Git
brew install git
brew install lazygit
brew install gh

# Pnpm
brew install pnpm

# Fzf
brew install fd fzf

# Tmux
brew install tmux

# Runtime
brew install node
# brew tap oven-sh/bun # for macOS and Linux
# brew install bun

# Raycast
brew install --cask raycast

# Redis
brew install redis

# Neofetch
brew install neofetch
