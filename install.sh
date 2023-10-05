#!/bin/sh

echo "Setup started"

cd "$(dirname "$0")"
export DOTFILES=$(pwd -P)
CONFIG_DIR="$HOME/.config"

function link_nvim() {
  echo "Symlinkling Neovim"

  NVIM_CONFIG_DIR="$CONFIG_DIR/nvim"

  # Remove nvim dir if it exists
  if [ -d "$NVIM_CONFIG_DIR" ]; then
    rm -rf $NVIM_CONFIG_DIR
  fi

  # Create .config directory if it doesn't exist
  if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p $CONFIG_DIR
  fi

  ln -s $DOTFILES/nvim $NVIM_CONFIG_DIR
}

function link_zshrc() {
  echo "Symlinkling zshrc"

  if [ -f "$HOME/.zshrc" ]; then
    rm $HOME/.zshrc
  fi

  ln -s $DOTFILES/zsh/zshrc $HOME/.zshrc
}

function link_gitconfig() {
  echo "Symlinkling gitconfig"

  if [ -f "$HOME/.gitconfig" ]; then
    rm $HOME/.gitconfig
  fi

  ln -s $DOTFILES/git/gitconfig $HOME/.gitconfig
}

function link_iterm_profiles() {
  echo "Symlinkling iTerm2 profiles"

  if [ -f "$CONFIG_DIR/iterm2/AppSupport/DynamicProfiles/night-owl.json" ]; then
    rm $CONFIG_DIR/iterm2/AppSupport/DynamicProfiles/night-owl.json
  fi

  ln -s $DOTFILES/iterm2/night-owl.json $CONFIG_DIR/iterm2/AppSupport/DynamicProfiles/night-owl.json
}

source ./bin/brew.sh
source ./bin/macos.sh

link_nvim
link_zshrc
link_gitconfig
link_iterm_profiles

cd $HOME # Go home

echo "Setup finished"
