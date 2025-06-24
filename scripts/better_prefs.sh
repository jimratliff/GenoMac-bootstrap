#!/usr/bin/env zsh

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
action_taken "Changing settings related to the user interface in general"

# Tap to click
adjust_setting "Turn on tap to click"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true;success

# Drag window with three fingers
adjust_setting "Turn on three-finger drag"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0;success

# Show scroll bars always (not only when scrolling)
adjust_setting "Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always";success

# Override change to clicking-on-desktop behavior
# Desktop & Dock » Desktop & Stage Manager » Click wallpaper to reveal desktop » Only in Stage Manager
adjust_setting "Reverse obnoxious default that revealed desktop anytime you clicked on the desktop"
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool true;success

########## Stop intrusive/arrogant “corrections”
# Turn off:
# - Correct spelling automatically
# - Capitalize words automatically
# - Add period with double-space
# - Use smart quotes and dashes
action_taken "Stop intrusive, arrogant, I-know-better-than-you “corrections”"

adjust_setting "Turn off automatic capitalization"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

adjust_setting "Don’t automatically substituted dash/hyphen types"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false;success

adjust_setting "Don’t automatically substitute periods"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false;success

adjust_setting "I’ll supply the intelligence for my quotation marks, thank you!"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false;success

adjust_setting "Don’t replace my properly considered spelling with your arrogant replacements"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false;success

adjust_setting "Don’t replace, in a web context, my properly considered spelling with your arrogant replacements"
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false;success

# Show Fast User Switching in menubar as Account Name
defaults write NSGlobalDomain userMenuExtraStyle -int 1;success

############### Finder

# Finder: Show all hidden files
# Does NOT correspond to any UI command
defaults write com.apple.finder AppleShowAllFiles true;success

# Finder: Show Pathbar
defaults write com.apple.finder ShowPathbar -bool true;success

# Finder: ShowStatusBar
defaults write com.apple.finder ShowStatusBar -bool true;success

# Finder: Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true;success

# Finder: Always show window proxy icon
defaults write com.apple.universalaccess showWindowTitlebarIcons -bool true;success

# Finder: Open new windows to Home
# This is intended for bootstrapping ONLY, not for enforcement
defaults write com.apple.finder NewWindowTarget -string "PfHm";success

# Finder: Show removable media (CDs, DVDs, etc.) on desktop
# This is the default. Included here to enforce the default if it is ever changed.
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true;success

# Finder: Show connected servers on desktop
# This is chosen only because these defaults are aimed at Admin accounts
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true;success

############### DiskUtility
# DiskUtility: Show all devices in sidebar
defaults read com.apple.DiskUtility SidebarShowAllDevices -bool true;success

############### Kill each affected app
action_taken "Force quitting all apps/processes whose settings we just changed."
for app in "Finder" "SystemUIServer"; do killall "${app}" > /dev/null 2>&1
done

