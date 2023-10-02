#!/bin/sh

echo "Setup started"

cd "$(dirname "$0")"
DOTFILES=$(pwd -P)

link_nvim() {
  echo "Installing Neovim"

  CONFIG_DIR="$HOME/.config"
  NVIM_CONFIG_DIR="$CONFIG_DIR/nvim"

  if [ -d "$CONFIG_DIR" ]; then
    cd $HOME/.config # Cd into .config directory

    if [ -d "$NVIM_CONFIG_DIR" ]; then
      rm -rf nvim # Remove nvim directory
      ln -s $HOME/dotfiles/nvim nvim # Symlink
    else
      ln -s $HOME/dotfiles/nvim nvim # Symlink
    fi
  else
    cd $HOME # Go home
    mkdir -p .config # Create .config directory
    cd .config # Cd into .config directory
    ln -s $HOME/dotfiles/nvim nvim # Symlink
  fi
}

link_zshrc() {
  echo "Installing zsh"

  ln -s $HOME/dotfiles/zsh/zshrc $HOME/.zshrc
}

link_gitconfig() {
  echo "Installing gitconfig"

  ln -s $HOME/dotfiles/git/gitconfig $HOME/.gitconfig
}

link_iterm_profiles() {
  echo "Installing iTerm2 profiles"

  ln -s $HOME/dotfiles/iterm2/night-owl.json $HOME/.config/iterm2/AppSupport/DynamicProfiles/night-owl.json
}

./bin/brew.sh
./bin/macos.sh

link_nvim
link_zshrc
link_gitconfig
link_iterm_profiles

echo "Setup finished"
