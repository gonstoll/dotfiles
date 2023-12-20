# Gonzalo Stoll's dotfiles

<img src="__images/screenshot.png" alt="Dotfiles screenshot" />

These are my dotfiles, use with caution and at your own risk! For the moment, this only works for macOS users.

## Features

- Editor - [Neovim](https://neovim.io/)
- Shell - [Zsh](https://www.zsh.org/)
- Terminal - [WezTerm](https://wezfurlong.org/wezterm/index.html)
- Multiplexer - [tmux](https://github.com/tmux/tmux/wiki)

## Basic Installation

Clone this repo and execute the `install` script:

```bash
git clone --recurse-submodules https://github.com/gonstoll/dotfiles.git ~/dotfiles
chmod +x ~/dotfiles/install.sh
~/dotfiles/install.sh
```

First, this script will let you choose whether to install or not a set of scripts for some base configuration:

- [Homebrew](https://brew.sh/) and a set of packages ([find them
  here](https://github.com/gonstoll/dotfiles/blob/master/bin/brew.sh))
- MacOS settings (things like key-repeat rate, menu bar icons. It even features mczachurski's
  [wallpapper](https://github.com/mczachurski/wallpapper) to let you easily setup dynamic wallpapers)
- Runtime scripts (like `npm` global packages)

Then, it will install the aforementioned features by symlinking them to their corresponding locations.

## Zsh

This script will place the `.zshrc` file under `~/.config/zsh`, which differs from the traditional location `~/.zshrc`.

## tmux

In order the get full advantage of the `tmux` configuration, firstly run:

```bash
chmod +x ~/dotfiles/tmux/bin/toggle-theme.sh
```

This will unblock some keybindings to toggle `tmux` theme.

Then, from within a `tmux` session (run `tmux` to start one) press `<C-a>` + `<C-I>` (ctrl/a + ctrl/shift/i) to install
`tmux`'s plugins.

## Consideration

Already have your own git/iTerm/nvim/etc configuration and don't want to lose it? Fear not! This script will let you
skip overriding them, or even back them up in case you want them for future reference.

Having said that, it may also install undesired configurations on your machine, so use at your own risk!
