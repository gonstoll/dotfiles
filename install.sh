#!/bin/sh

cd "$(dirname "$0")"
export DOTFILES=$(pwd -P)

echo ">> Setup started"
echo ""

chmod +x $DOTFILES/bin/u
chmod +x $DOTFILES/bin/code_extensions
chmod +x $DOTFILES/tmux/bin/toggle-theme.sh

function install_preferences() {
  read -p "Do you want to install system preferences? (y/n) " yn < /dev/tty
  case $yn in
    [Yy]* ) source ./scripts/macos.sh; break ;;
    [Nn]* ) echo ">>> Skipped installing system preferences"; return ;;
    * ) echo ">>> Incorrect option, skipping"; return ;;
  esac

  echo ">>> Finished installing system preferences"
}

function install_packages() {
  read -p "Do you want to install system packages? (y/n) " yn < /dev/tty
  case $yn in
    [Yy]* )
      echo ">>> Installing Homebrew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

      echo ">>> Installing Homebrew depedencies"
      echo "export HOMEBREW_BUNDLE_FILE=$DOTFILES/Brewfile" >> $ZDOTDIR/.zshrc
      brew bundle --file=$DOTFILES/Brewfile
      break ;;
    [Nn]* ) echo ">>> Skipped installing system packages"; return ;;
    * ) echo ">>> Incorrect option, skipping"; return ;;
  esac

  echo ">>> Finished installing system packages"
}

function install_misc_packages() {
  read -p "Do you want to install global misc packages? (y/n) " yn < /dev/tty
  case $yn in
    [Yy]* ) source ./scripts/misc.sh; break ;;
    [Nn]* ) echo ">>> Skipped installing global misc packages"; return ;;
    * ) echo ">>> Incorrect option, skipping"; return ;;
  esac

  echo ">>> Finished installing global misc packages"
}

function install_dotfiles() {
  STOW_PACKAGES=(bin git iterm2 neofetch nvim tmux vscode wezterm zsh)
  read -p "Do you want to install package configurations? (y/n) " yn < /dev/tty
  case $yn in
    [Yy]* ) stow -v $STOW_PACKAGES; break ;;
    [Nn]* ) echo ">>> Skipped installing package configurations"; return ;;
    * ) echo ">>> Incorrect option, skipping"; return ;;
  esac

  echo ">>> Finished installing package configurations"
}

install_preferences
echo ""
install_packages
echo ""
install_misc_packages
echo ""
install_dotfiles

cd $HOME # Go home

echo ">> Setup finished"
