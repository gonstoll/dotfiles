#!/bin/sh

echo "> Setting system defaults"

# ~/.macos — https://mths.be/macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Add custom .zshrc path
sudo tee -a /etc/zshenv >/dev/null <<'EOF'

if [[ -z "$XDG_CONFIG_HOME" ]]
then
	export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]
then
	export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"
fi
EOF

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

# Enable menu-bar icons
defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
  "/System/Library/CoreServices/Menu Extras/Clock.menu" \
  "/System/Library/CoreServices/Menu Extras/Battery.menu" \
  "/System/Library/CoreServices/Menu Extras/Volume.menu"

killall SystemUIServer

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# VSCode: disable the Apple press and hold for VSCode only
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
