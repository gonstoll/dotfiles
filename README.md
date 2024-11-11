## Gonzalo Stoll's dotfiles

<img src="__images/screenshot.png" alt="Dotfiles screenshot" />

These are my dotfiles. They are not meant to be used as is, but feel free to
take whatever you want from them.

## Features

Some of the programs and systems used in these dotfiles are:

- Editor - [Neovim](https://neovim.io/)
- Shell - [Zsh](https://www.zsh.org/)
- Terminal - [WezTerm](https://wezfurlong.org/wezterm/index.html)
- Multiplexer - [tmux](https://github.com/tmux/tmux/wiki)

## Installation

You can install these dotfiles in two ways:

#### With cURL (recommended)

Execute the following command:

```sh
bash -c "$(curl -fsSL raw.github.com/gonstoll/dotfiles/master/.local/bin/dotfiles)"
```

#### Cloning the repository

Clone the repository and execute the `dotfiles` script:

```sh
git clone https://github.com/gonstoll/dotfiles.git ~/.dotfiles
chmod +x ~/.dotfiles/.local/bin/dotfiles && ~/.dotfiles/.local/bin/dotfiles
```

## What does the installation script do?

The script will guide you through the installation process. It will attempt to
install [homebrew](https://brew.sh/), [git](https://git-scm.com/), sync its git
submodules and link its packages by using [GNU
Stow](https://www.gnu.org/software/stow/).

You can customize its installation by setting some flags:

#### No homebrew and runtime packages

This script installs all homebrew and runtime (`npm`, `bun`, `cargo`, etc.)
packages. You can opt-out of this by setting the `--no-packages` flag:

```sh
# First time installing:
bash -c "$(curl -fsSL raw.github.com/gonstoll/dotfiles/master/.local/bin/dotfiles) -- --no-packages"

# ...or after installation:
dotfiles --no-packages
```

#### No git syncronization

Git syncronization checks for updates in the dotfiles repository and installs
its submodules. You can opt-out of this by setting the `--no-sync` flag:

```sh
# First time installing:
bash -c "$(curl -fsSL raw.github.com/gonstoll/dotfiles/master/.local/bin/dotfiles) -- --no-sync"

# ...or after installation:
dotfiles --no-sync
```

## Acknowledgements

A lot of inspiration for the architecture of these dotfiles came from:

- [@necolas](https://github.com/necolas/dotfiles/tree/master)
- [@typecraft](https://github.com/typecraft-dev/dotfiles)
- [@andrew8088](https://github.com/andrew8088/dotfiles)
