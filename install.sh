#!/bin/sh

echo "Setup started"

cd "$(dirname "$0")"
export DOTFILES=$(pwd -P)

function link_nvim() {
  echo "Symlinkling Neovim"

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

function link_zshrc() {
  echo "Symlinkling zshrc"

  ln -s $HOME/dotfiles/zsh/zshrc $HOME/.zshrc
}

function link_gitconfig() {
  echo "Symlinkling gitconfig"

  ln -s $HOME/dotfiles/git/gitconfig $HOME/.gitconfig
}

function link_iterm_profiles() {
  echo "Symlinkling iTerm2 profiles"

  ln -s $HOME/dotfiles/iterm2/night-owl.json $HOME/.config/iterm2/AppSupport/DynamicProfiles/night-owl.json
}

./bin/brew.sh
./bin/macos.sh

link_nvim
link_zshrc
link_gitconfig
link_iterm_profiles

echo "Setup finished"
