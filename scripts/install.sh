#!/usr/bin/env bash

echo ""
echo "=========================================="
echo "  Okami Dotfiles - Installation"
echo "=========================================="
echo ""

# get sudo password for the lifetime of the script
printf "your password is required\n"
sleep 1
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

echo ""
echo "=========================================="
echo "  xCode - Installation"
echo "=========================================="
echo ""

# Install xCode cli tools
echo "Installing commandline tools..."
xcode-select --install

sleep 5

echo ""
echo "=========================================="
echo "  Homebrew - Installation"
echo "=========================================="
echo ""

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
  echo "[ERROR] Homebrew is not installed"
  echo "Will be installing Homebrew..."
fi

sleep 5

# Homebrew Check
if ! command -v "brew" &>/dev/null; then
  printf "installing homebrew\n"
  # install homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # set it in the terminal
  eval "$(/opt/homebrew/bin/brew shellenv)"
  # Turn the analytics off
  brew analytics off
fi

# Homebrew Packages
printf "installing homebrew packages\n"
quiet brew bundle

echo ""
echo "=========================================="
echo "  MacApps - Installation"
echo "=========================================="
echo ""

printf "Installing app store apps..."
APP_STORE_APPS=(
  6743346144 # Classic Loan Calculator
  1545870783 # Color Picker
  6747984907 # Prompt2Go
  899247664  # TestFlight
  0          # THOHT
)
for app in "${APP_STORE_APPS[@]}"; do
  mas install $app
done

# Xcode
printf "setup xcode\n"
quiet xcodes install --latest --select --no-superuser --experimental-unxip

echo ""
echo "=========================================="
echo "  macOS Settings - Setup"
echo "=========================================="
echo ""

# macOS Settings
echo "Changing macOS defaults..."
defaults write com.apple.dock "orientation" -string "bottom"
defaults write com.apple.dock "tilesize" -int "30"
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "autohide-time-modifier" -float "0"
defaults write com.apple.dock "autohide-delay" -float "0"
defaults write com.apple.dock "show-recents" -bool "false"
defaults write com.apple.dock "mineffect" -string "scale"
defaults write com.apple.dock "scroll-to-open" -bool "true"
defaults write com.apple.screencapture "disable-shadow" -bool "true"
defaults write com.apple.finder "QuitMenuItem" -bool "true"
defaults write com.apple.finder "DisableAllAnimations" -bool true
defaults write com.apple.finder "ShowExternalHardDrivesOnDesktop" -bool false
defaults write com.apple.finder "ShowHardDrivesOnDesktop" -bool false
defaults write com.apple.finder "ShowMountedServersOnDesktop" -bool false
defaults write com.apple.finder "ShowRemovableMediaOnDesktop" -bool false
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write com.apple.finder "ShowPathbar" -bool "true"
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCev"
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "true"
defaults write com.apple.universalaccess "showWindowTitlebarIcons" -bool "true"
defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "1"
defaults write com.apple.finder "CreateDesktop" -bool "false" && killall Finder
defaults write com.apple.menuextra.clock "FlashDateSeparators" -bool "true" && killall SystemUIServer
defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE d MMM HH:mm:ss\""
defaults write NSGlobalDomain com.apple.mouse.scaling -float "3.0"
defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "0"
defaults write com.apple.AppleMultitouchTrackpad "DragLock" -bool "false"
defaults write com.apple.AppleMultitouchTrackpad "Dragging" -bool "false"
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"
defaults write com.apple.dock "mru-spaces" -bool "false"
defaults write com.apple.dock "expose-group-apps" -bool "false" && killall Dock

echo ""
echo "=========================================="
echo "  Services - Start"
echo "=========================================="
echo ""

# Start Services
echo "Starting Services (grant permissions)..."
yabai --start-service
sleep 5
skhd --start-service
sleep 5
brew services start sketchybar
sleep 5
brew services start borders
sleep 5

csrutil status
echo "(optional) Disable SIP for advanced yabai features."

sleep 3

# Fresh installation

echo ""
echo "=========================================="
echo "  Installation Complete!"
echo "=========================================="
echo ""
