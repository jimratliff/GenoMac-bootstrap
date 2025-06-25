#!/usr/bin/env zsh

# Implements selected `defaults` command for the admin accounts, to remove the 
# biggest annoyances ASAP during bootstrapping.

# action_taken "Message"
# adjust_setting "Message"

#↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ BEGIN section ONLY for VANILLA/CONFIGURER accounts
action_taken "Adjust settings appropriately for only SysAdmin account"


# Finder: Show hard drives on desktop
# This is chosen only because these defaults are aimed at Admin accounts
adjust_setting "Show hard drives on desktop"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true&&success

# Finder: Show external drives on desktop
# This is the default. Included here to enforce the default if it is ever changed.
adjust_setting "Show external drives on desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true&&success

#↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ END section ONLY for VANILLA/CONFIGURER accounts

############### General interface
action_taken "Changing settings related to the user interface in general"

# Tap to click
adjust_setting "Turn on tap to click"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true&&success

########## Drag window with three fingers
action_taken "Turn on three-finger drag"

adjust_setting "1 of 3: TrackpadThreeFingerDrag: true"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true&&success
adjust_setting "2 of 3: TrackpadThreeFingerHorizSwipeGesture: 0"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0&&success
adjust_setting "3 of 3: TrackpadThreeFingerVertSwipeGesture: 0"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0&&success

# Show scroll bars always (not only when scrolling)
adjust_setting "Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"&&success

# Override change to clicking-on-desktop behavior
# Desktop & Dock » Desktop & Stage Manager » Click wallpaper to reveal desktop » Only in Stage Manager
adjust_setting "Reverse obnoxious default that revealed desktop anytime you clicked on the desktop"
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool true&&success

########## Stop intrusive/arrogant “corrections”
# Turn off:
# - Correct spelling automatically
# - Capitalize words automatically
# - Add period with double-space
# - Use smart quotes and dashes
action_taken "Stop intrusive, arrogant, I-know-better-than-you “corrections”"

adjust_setting "1 of 6: Turn off automatic capitalization"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false&&success

adjust_setting "2 of 6: Don’t automatically substituted dash/hyphen types"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false&&success

adjust_setting "3 of 6: Don’t automatically substitute periods"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false&&success

adjust_setting "4 of 6: I’ll supply the intelligence for my quotation marks, thank you!"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false&&success

adjust_setting "5 of 6: Don’t replace my properly considered spelling with your arrogant replacements"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false&&success

adjust_setting "6 of 6: Don’t replace, in a web context, my properly considered spelling with your arrogant replacements"
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false&&success

# Show Fast User Switching in menubar as Account Name
adjust_setting "Show Fast User Switching in menubar as Account Name"
defaults write NSGlobalDomain userMenuExtraStyle -int 1&&success

############### Finder

action_taken "Adjust settings for Finder"

# Finder: Show all hidden files
# Does NOT correspond to any UI command
adjust_setting "Show all hidden files (i.e., “dot files”)"
defaults write com.apple.finder AppleShowAllFiles true&&success

# Finder: Show Pathbar
adjust_setting "Show path bar"
defaults write com.apple.finder ShowPathbar -bool true&&success

# Finder: ShowStatusBar
adjust_setting "Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true&&success

# Finder: Show all filename extensions
adjust_setting "Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true&&success

# Finder: Always show window proxy icon
adjust_setting "Always show window proxy icon"
defaults write com.apple.universalaccess showWindowTitlebarIcons -bool true&&success

# Finder: Open new windows to Home
# This is intended for bootstrapping ONLY, not for enforcement
adjust_setting "By default, new Finder window should open to user’s home directory"
defaults write com.apple.finder NewWindowTarget -string "PfHm"&&success

# Finder: Show removable media (CDs, DVDs, etc.) on desktop
# This is the default. Included here to enforce the default if it is ever changed.
adjust_setting "Show removable media (CDs, DVDs, etc.) on desktop"
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true&&success

# Finder: Show connected servers on desktop
# This is chosen only because these defaults are aimed at Admin accounts
adjust_setting "This is chosen only because these defaults are aimed at Admin accounts"
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true&&success

############### DiskUtility
# DiskUtility: Show all devices in sidebar
adjust_setting "DiskUtility: Show all devices in sidebar"
defaults write com.apple.DiskUtility SidebarShowAllDevices -bool true&&success

############### Kill each affected app
action_taken "Force quitting all apps/processes whose settings we just changed."
for app in "Finder" "SystemUIServer"; do
  killall "${app}" && printf "Killed app: %s\n" "$app"&&success
done

