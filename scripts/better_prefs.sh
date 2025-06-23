#!/bin/bash

# Implements selected `defaults` command for the admin accounts, to remove the 
# biggest annoyances ASAP during bootstrapping.

#↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ BEGIN section ONLY for VANILLA/CONFIGURER accounts

# Finder: Show hard drives on desktop
# This is chosen only because these defaults are aimed at Admin accounts
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true

# Finder: Show external drives on desktop
# This is the default. Included here to enforce the default if it is ever changed.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

#↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ END section ONLY for VANILLA/CONFIGURER accounts

############### General interface
# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Drag window with three fingers
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0

# Show scroll bars always (not only when scrolling)
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Override change to clicking-on-desktop behavior
# Desktop & Dock » Desktop & Stage Manager » Click wallpaper to reveal desktop » Only in Stage Manager
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool true

########## Stop intrusive/arrogant “corrections”
# Turn off:
# - Correct spelling automatically
# - Capitalize words automatically
# - Add period with double-space
# - Use smart quotes and dashes
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

# Show Fast User Switching in menubar as Account Name
defaults write NSGlobalDomain userMenuExtraStyle -int 1

############### Finder

# Finder: Show all hidden files
# Does NOT correspond to any UI command
defaults write com.apple.finder AppleShowAllFiles true

# Finder: Show Pathbar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: ShowStatusBar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: Always show window proxy icon
defaults write com.apple.universalaccess showWindowTitlebarIcons -bool true

# Finder: Open new windows to Home
# This is intended for bootstrapping ONLY, not for enforcement
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Finder: Show removable media (CDs, DVDs, etc.) on desktop
# This is the default. Included here to enforce the default if it is ever changed.
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: Show connected servers on desktop
# This is chosen only because these defaults are aimed at Admin accounts
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

############### DiskUtility
# DiskUtility: Show all devices in sidebar
defaults read com.apple.DiskUtility SidebarShowAllDevices -bool true


