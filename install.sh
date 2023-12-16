#!/bin/sh
# Script heavily inspired by https://github.com/andrew8088/dotfiles/blob/main/install/bootstrap.sh

cd "$(dirname "$0")"
export DOTFILES=$(pwd -P)

echo ">>> Setup started"
echo ""

chmod +x $DOTFILES/bin/u

function install_system() {
  read -p "Do you want to install system packages? (y/n) " yn < /dev/tty
  case $yn in
    [Yy]* ) source ./bin/brew.sh; break ;;
    [Nn]* ) echo "> Skipped installing system packages"; return ;;
    * ) echo "> Incorrect option, skipping"; return ;;
  esac

  echo "> Finished installing system packages"
}

function install_preferences() {
  read -p "Do you want to install system preferences? (y/n) " yn < /dev/tty
  case $yn in
    [Yy]* ) source ./bin/macos.sh; break ;;
    [Nn]* ) echo "> Skipped installing system preferences"; return ;;
    * ) echo "> Incorrect option, skipping"; return ;;
  esac

  echo "> Finished installing system preferences"
}

function install_runtime_packages() {
  read -p "Do you want to install global runtime packages? (y/n) " yn < /dev/tty
  case $yn in
    [Yy]* ) source ./bin/runtime.sh; break ;;
    [Nn]* ) echo "> Skipped installing global runtime packages"; return ;;
    * ) echo "> Incorrect option, skipping"; return ;;
  esac

  echo "> Finished installing global runtime packages"
}

function link_files() {
  local src=$1 dst=$2

  local skip=
  local overwrite=
  local backup=
  local action=

  if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]
  then

    local first_line="Path to $dst already exists, what do you want to do?"
    local second_line="[o]verwrite, [s]kip, [S]kip all, [b]ackup?"
    read -p "$first_line $second_line " yn < /dev/tty

    case $yn in
      [S]* ) echo "> Skipped symlinking all duplicated files"; break ;;
      [s]* ) echo "> Skipped symlinking $(basename "$src")"; skip=true ;;
      [o]* ) overwrite=true ;;
      [b]* ) backup=true ;;
      * ) echo "> Incorrect option, skipping"; skip=true ;;
    esac


    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      echo "> Removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      echo "> Moved $dst to ${dst}.backup"
    fi

  fi

  if [ "$skip" != "true" ]
  then
    ln -s "$src" "$dst"
    echo "> Linked $1 to $2"
  fi

  echo ""
}

function install_dotfiles() {
  echo "> Installing dotfiles"

  find . -name "link.prop" -type f -exec cat {} \; | while IFS= read -r line;
  do
    local src=$(eval echo "$line" | cut -d '=' -f 1)
    local dst=$(eval echo "$line" | cut -d '=' -f 2)
    local dir=$(dirname "$dst")

    mkdir -p $dir

    link_files "$src" "$dst"
  done
}

install_system
echo ""
install_preferences
echo ""
install_runtime_packages
echo ""
install_dotfiles

cd $HOME # Go home

echo ">>> Setup finished"
