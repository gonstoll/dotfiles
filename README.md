# Dotfiles

These are my dotfiles, use with caution and at your own risk! For the moment, this only works for macOS users.

| Dark mode                                                                            | Light mode                                                                             |
| ------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------- |
| <img src="__images/dark-mode-1.png" alt="Neovim dark mode screenshot - Dashboard" /> | <img src="__images/light-mode-1.png" alt="Neovim light mode screenshot - Dashboard" /> |
| <img src="__images/dark-mode-2.png" alt="Neovim dark mode screenshot" />             | <img src="__images/light-mode-2.png" alt="Neovim light mode screenshot" />             |

## Features

- Editor - [Neovim](https://neovim.io/)
- Shell - [Zsh](https://www.zsh.org/)
- Terminal - [iTerm2](https://iterm2.com/)
- Launcher - [Raycast](https://www.raycast.com/)

## Basic Installation

Clone this repo and execute the `install` script:

```bash
git clone --recurse-submodules https://github.com/gonstoll/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

First, this script will let you choose whether to install or not a set of scripts for some base configuration:

- [Homebrew](https://brew.sh/) and a set of packages ([find them
  here](https://github.com/gonstoll/dotfiles/blob/master/bin/brew.sh))
- MacOS settings
- Runtime packages (`npm` global packages)

Then, it will install the mentioned features by symlinking them to their corresponding locations.
