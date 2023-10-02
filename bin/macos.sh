#!/bin/sh

echo "Setting system defaults"

# ~/.macos — https://mths.be/macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Set a blazingly fast keyboard repeat rate
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 13

# Sync iTerm2 configs
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/dotfiles/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

# Set wallpaper to one of the dynamic wallpapers
wallpaper_image_path="$DOTFILES/system/wallpapers/images/tokyo-nyc/output.heic"
osascript -e 'tell application "System Events" to set picture of every desktop to POSIX file "'$wallpaper_image_path'"'
# Set a random wallpaper
# osascript -e 'tell application "Finder" to set desktop picture to POSIX file "$(find ~/dotfiles/system/wallpapers -name "*.heic" -type f | shuf -n 1)"'
