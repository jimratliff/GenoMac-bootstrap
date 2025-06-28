#!/usr/bin/env zsh

# Source scripts/helpers.sh
source "${0:A:h}/helpers.sh"

# Implements selected `defaults` command for the admin accounts, to remove the 
# biggest annoyances ASAP during bootstrapping.
#
# Because this is for bootstrapping, any settings that act upon, or require, software no pre-installed on the Mac, must wait.

# report_action_taken "Message"
# report_adjust_setting "Message"

#↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ BEGIN section that requires sudo
report_action_taken "Begin commands that require 'sudo'"
report_action_taken "I very likely am about to ask you for your administrator password. Do you trust me??? 😉"
# Update user’s cached credentials for `sudo`.
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do 
  sudo -n true          # non-interactively refresh sudo timestamp (fails silently if not authorized)
  sleep 60              # wait one minute
  kill -0 "$$" || exit  # exit if the parent shell no longer exists
done 2>/dev/null &      # run loop in background, silence stderr

############### Get login-window text
report_action_taken "Set login-window text"
while true; do
  echo -n "Please enter your desired login-window text: "
  read user_input

  echo "You entered: \"$user_input\""
  echo -n "Is this correct? (y/n): "
  read confirmation

  if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    break
  fi
done

echo "Final choice: \"$user_input\""
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string "$user_input";success_or_not

############### Configure application firewall
report_action_taken "Configure application firewall"
report_adjust_setting "1 of 2: Enable application firewall"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on;success_or_not
report_adjust_setting "2 of 2: Enable Stealth Mode"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on;success_or_not

############### System-wide settings controlling software-update behavior
report_action_taken "Implement system-wide settings controlling how macOS and MAS-app software updates occur"

report_adjust_setting "Automatically check for updates (both macOS and MAS apps)"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true;success_or_not

report_adjust_setting "Download updates when available"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true;success_or_not

report_adjust_setting "Do NOT automatically update macOS"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool false;success_or_not

report_adjust_setting "Automatically update applications from Mac App Store"
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true;success_or_not

report_adjust_setting "Display additional information (IP address, hostname, OS version, etc.) when clicking on the clock in upper-right corner of the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName;success_or_not

report_action_taken "End commands that require 'sudo'"
#↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ END section that requires sudo

#↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ BEGIN section ONLY for VANILLA/CONFIGURER accounts
report_action_taken "Adjust certain settings in a way appropriate for only SysAdmin account (but not for other accounts)"

# Finder: Show hard drives on desktop
# This is chosen only because these defaults are aimed at Admin accounts
report_adjust_setting "Show hard drives on desktop"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true;success_or_not

# Finder: Show external drives on desktop
# This is the default. Included here to enforce the default if it is ever changed.
report_adjust_setting "Show external drives on desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true;success_or_not

#↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ END section ONLY for VANILLA/CONFIGURER accounts

############### Enable app-state persistence
report_action_taken "Implement app-state persistence"

report_adjust_setting "1 of 3: loginwindow: TALLogoutSavesState: true"
defaults write com.apple.loginwindow TALLogoutSavesState -bool true;success_or_not
report_adjust_setting "2 of 3: loginwindow: LoginwindowLaunchesRelaunchApps: true"
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool true;success_or_not
report_adjust_setting "3 of 3: NSGlobalDomain: NSQuitAlwaysKeepsWindows: true"
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true;success_or_not

############### General interface
report_action_taken "Change settings related to the user interface in general"

# Tap to click
report_adjust_setting "Turn on tap to click"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true;success_or_not

########## Drag window with three fingers
report_action_taken "Turn on three-finger drag"

report_adjust_setting "1 of 3: TrackpadThreeFingerDrag: true"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true;success_or_not
report_adjust_setting "2 of 3: TrackpadThreeFingerHorizSwipeGesture: 0"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0;success_or_not
report_adjust_setting "3 of 3: TrackpadThreeFingerVertSwipeGesture: 0"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0;success_or_not

# Show scroll bars always (not only when scrolling)
report_adjust_setting "Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always";success_or_not

# Override change to clicking-on-desktop behavior
# Desktop & Dock » Desktop & Stage Manager » Click wallpaper to reveal desktop » Only in Stage Manager
report_adjust_setting "Reverse obnoxious default that revealed desktop anytime you clicked on the desktop"
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false;success_or_not

# Window tabbing mode
report_adjust_setting "AppleWindowTabbingMode: manual ⇒ Window should display at tabs according to window’s tabbing mode”"
defaults write NSGlobalDomain AppleWindowTabbingMode -string "manual";success_or_not

########## Stop intrusive/arrogant “corrections”
# Turn off:
# - Correct spelling automatically
# - Capitalize words automatically
# - Add period with double-space
# - Use smart quotes and dashes
report_action_taken "Stop intrusive, arrogant, I-know-better-than-you “corrections”"

report_adjust_setting "1 of 6: Turn off automatic capitalization"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false;success_or_not
report_adjust_setting "2 of 6: Don’t automatically substitute dash/hyphen types"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false;success_or_not
report_adjust_setting "3 of 6: Don’t automatically substitute periods"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false;success_or_not
report_adjust_setting "4 of 6: I’ll supply the intelligence for my quotation marks, thank you!"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false;success_or_not
report_adjust_setting "5 of 6: Don’t replace my properly considered spelling with your arrogant replacements"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false;success_or_not
report_adjust_setting "6 of 6: Don’t replace, in a web context, my properly considered spelling with your arrogant replacements"
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false;success_or_not

############### Menubar

########## Show Fast User Switching in menubar as Account Name
report_action_taken "Show Fast User Switching in menubar only as Account Name"
report_adjust_setting "1 of 2: userMenuExtraStyle = 1 (Account Name)"
defaults write NSGlobalDomain userMenuExtraStyle -int 1;success_or_not
report_adjust_setting "2 of 2: UserSwitcher = 2 (menubar only)"
defaults -currentHost write com.apple.controlcenter UserSwitcher -int 2;success_or_not

# Always show Sound in menubar
report_adjust_setting "Always show Sound in menubar (not only when “active”)"
defaults -currentHost write com.apple.controlcenter sound -int 18;success_or_not

# Show battery percentage in menubar
report_adjust_setting "Show battery percentage in menubar"
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true;success_or_not

############### Control Center

########## Add Bluetooth to Control Center to access battery percentages of Bluetooth devices

report_adjust_setting "Add Bluetooth to Control Center to access battery percentages of Bluetooth devices"
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true;success_or_not

############### Dock
report_action_taken "Implement Dock settings"

report_adjust_setting "Dock: Turn on magnification effect when hovering over Dock"
defaults write com.apple.dock magnification -bool true;success_or_not

report_adjust_setting "Dock: Set size of magnified Dock icons"
defaults write com.apple.dock largesize -float 128;success_or_not

report_adjust_setting "Dock: Show indicator lights for open apps"
defaults write com.apple.dock show-process-indicators -bool true;success_or_not

# This isn’t working for me (6/27/2025 on M1 Mac mini)
report_adjust_setting "Make Dock icons of hidden apps translucent"
defaults write com.apple.Dock showhidden -bool true;success_or_not

report_adjust_setting "Highlight the element of a grid-view Dock stack over which the cursor hovers"
defaults write com.apple.dock mouse-over-hilte-stack -bool true;success_or_not

report_adjust_setting "Dock: Turn OFF automatic hide/show the Dock"
defaults write com.apple.dock autohide -bool false;success_or_not

report_adjust_setting "Dock: Enable two-finger scrolling on Dock icon to reveal thumbnails of all windows for that app"
defaults write com.apple.dock scroll-to-open -bool true;success_or_not

report_adjust_setting "Disable the Launchpad gesture (pinch with thumb and three fingers)"
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0;success_or_not

############### Mission Control/Spaces
report_action_taken "Implement settings related to Space (Mission Control)"

report_adjust_setting "Spaces: Don’t rearrange based on most-recent use"
defaults write com.apple.dock mru-spaces -bool false;success_or_not

report_adjust_setting "Spaces span all display (no separate space for each monitor)"
defaults write com.apple.spaces "spans-displays" -bool "true";success_or_not

report_adjust_setting "Do not jump to a new space when switching applications"
defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool false;success_or_not

############### Finder

report_action_taken "Adjust settings for Finder"

# Finder: Show all hidden files
# Does NOT correspond to any UI command
report_adjust_setting "Show all hidden files (i.e., “dot files”)"
defaults write com.apple.finder AppleShowAllFiles true;success_or_not

# Finder: Show Pathbar
report_adjust_setting "Show path bar"
defaults write com.apple.finder ShowPathbar -bool true;success_or_not

# Finder: ShowStatusBar
report_adjust_setting "Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true;success_or_not

# Finder: Show all filename extensions
report_adjust_setting "Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true;success_or_not

# Finder: Always show window proxy icon
report_adjust_setting "Always show window proxy icon"
defaults write com.apple.universalaccess showWindowTitlebarIcons -bool true;success_or_not

# Finder: Open new windows to Home
# This is intended for bootstrapping ONLY, not for enforcement
report_adjust_setting "By default, new Finder window should open to user’s home directory"
defaults write com.apple.finder NewWindowTarget -string "PfHm";success_or_not

# Finder: Show removable media (CDs, DVDs, etc.) on desktop
# This is the default. Included here to enforce the default if it is ever changed.
report_adjust_setting "Show removable media (CDs, DVDs, etc.) on desktop"
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true;success_or_not

# Finder: Show connected servers on desktop
# This is chosen only because these defaults are aimed at Admin accounts
report_adjust_setting "Show connected servers on desktop"
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true;success_or_not

############### DiskUtility
# Launch and quit DiskUtility in order that it will have preferences to modify.
report_action_taken "Launch and quit DiskUtility in order that it will have preferences to modify"
open -b com.apple.DiskUtility # By bundle ID (more reliable than `open -a` by display name)
sleep 2
osascript -e 'quit app "Disk Utility"'

# DiskUtility: Show all devices in sidebar
report_adjust_setting "DiskUtility: Show all devices in sidebar"
defaults write com.apple.DiskUtility SidebarShowAllDevices -bool true;success_or_not

############### Kill each affected app
report_action_taken "Force quit all apps/processes whose settings we just changed"
apps_to_kill=(
  "Finder"
  "SystemUIServer"
  "Dock"
  "cfprefsd"
)

for app_to_kill in "${apps_to_kill[@]}"; do
  report_about_to_kill_app "$app_to_kill"
  killall "$app_to_kill";success_or_not
done

report "It’s possible that some settings won’t take effect until after you logout or restart."

