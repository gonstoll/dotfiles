#!/bin/sh

echo "Setup started"

cd "$(dirname "$0")"
export DOTFILES=$(pwd -P)
CONFIG_DIR="$HOME/.config"

function link_nvim() {
  echo "Symlinkling Neovim"

  NVIM_CONFIG_DIR="$CONFIG_DIR/nvim"

  if [ -d "$CONFIG_DIR" ]; then
    cd $HOME/.config # Cd into .config directory

    if [ -d "$NVIM_CONFIG_DIR" ]; then
      rm -rf nvim # Remove nvim directory
    fi

    ln -s $HOME/dotfiles/nvim nvim # Symlink
  else
    mkdir -p $CONFIG_DIR # Create .config directory
    ln -s $HOME/dotfiles/nvim $CONFIG_DIR/nvim # Symlink
  fi
}

function link_zshrc() {
  echo "Symlinkling zshrc"

  if [ -f "$HOME/.zshrc" ]; then
    rm $HOME/.zshrc
  fi

  ln -s $HOME/dotfiles/zsh/zshrc $HOME/.zshrc
}

function link_gitconfig() {
  echo "Symlinkling gitconfig"

  ln -s $HOME/dotfiles/git/gitconfig $HOME/.gitconfig
}

function link_iterm_profiles() {
  echo "Symlinkling iTerm2 profiles"

  ln -s $HOME/dotfiles/iterm2/night-owl.json $CONFIG_DIR/iterm2/AppSupport/DynamicProfiles/night-owl.json
}

source ./bin/brew.sh
source ./bin/macos.sh

link_nvim
link_zshrc
link_gitconfig
link_iterm_profiles

cd $HOME # Go home

echo "Setup finished"
