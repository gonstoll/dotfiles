#!/bin/sh

echo "Setup started"

CONFIG_DIR="~/.config"

link_nvim() {
  echo "Installing Neovim"

  NVIM_CONFIG_DIR="$CONFIG_DIR/nvim"

  if [ -d "$CONFIG_DIR" ]; then
    cd .config # Cd into .config directory

    if [ -d "$NVIM_CONFIG_DIR" ]; then
      rm -rf nvim # Remove nvim directory
      ln -s ~/dotfiles/nvim nvim # Symlink
    else
      ln -s ~/dotfiles/nvim nvim # Symlink
    fi
  else
    cd # Go home
    mkdir -p .config # Create .config directory
    cd .config # Cd into .config directory
    ln -s ~/dotfiles/nvim nvim # Symlink
  fi
}

link_zshrc() {
  echo "Installing zsh"

  ln -s ~/dotfiles/zsh/zshrc ~/.zshrc
}

link_gitconfig() {
  echo "Installing gitconfig"

  ln -s ~/dotfiles/git/gitconfig ~/.gitconfig
}

link_iterm_profiles() {
  echo "Installing iTerm2 profiles"

  ln -s ~/dotfiles/iterm2/dynamic-profiles.json ~/.config/iterm2/AppSupport/DynamicProfiles/dynamic-profiles.json
}

link_nvim
link_zshrc
link_gitconfig
link_iterm_profiles

echo "Setup finished"
