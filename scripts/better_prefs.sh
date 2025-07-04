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

report_adjust_setting "Display additional info (IP address, hostname, OS version) when clicking on the clock digits of the login window"
# Requires restart.
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

########## Trackpad
#
#  Implements the following choices
#  Point & Click
#    Tracking speed: 7 (on a scale from 0 to 9)
#    Click: Medium
#    Quiet Click: No
#    Force Click and haptic feedback: Yes
#    Look up & data detectors: Force Click with One Finger
#    Secondary click: Click or Tap with Two Fingers
#    Tap to click: Yes
#  Scroll & Zoom
#    Natural scrolling: Yes
#    Zoom in or out: Yes
#    Smart zoom: Yes
#    Rotate: Yes
#  More Gestures
#    Swipe between pages: Scroll Left or Right with Two Fingers
#    Swipe between full-screen applications: No
#    Notification Center: No
#    Mission Control: Swipe Up with Four Fingers
#    App Exposé: No
#    Launchpad: No
#    Show Desktop: Yes

report_action_taken "Implement configuration of Trackpad behavior"

report_adjust_setting "Point & Click: Tracking speed"
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2 ;success_or_not

report_action_taken "Point & Click: Click firmness"
report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: FirstClickThreshold"
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 1 ;success_or_not
report_adjust_setting "#2: c.a.AppleMultitouchTrackpad: SecondClickThreshold"
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 1 ;success_or_not
report_adjust_setting "Point & Click: Quiet Click"
defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 1 ;success_or_not

report_action_taken "Point & Click: Force Click"
report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: ActuateDetents"
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -int 1 ;success_or_not
report_adjust_setting "#2: c.a.AppleMultitouchTrackpad: ForceSuppressed"
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool false ;success_or_not
report_adjust_setting "#3: c.a.AppleMultitouchTrackpad: TrackpadThreeFingerTapGesture"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0 ;success_or_not
report_adjust_setting "#4: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadThreeFingerTapGesture"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0 ;success_or_not
report_adjust_setting "#5: c.a.preference.trackpad: ForceClickSavedState"
defaults write com.apple.preference.trackpad ForceClickSavedState -bool true ;success_or_not
report_adjust_setting "#6: -cH -g: c.a.trackpad.threeFingerTapGesture"
defaults -currentHost write  NSGlobalDomain com.apple.trackpad.threeFingerTapGesture -int 0 ;success_or_not

report_adjust_setting "Point & Click: Lookup & data detectors"
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true ;success_or_not

report_action_taken "Point & Click: Secondary click"
report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadRightClick"
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true ;success_or_not
report_adjust_setting "#2: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadRightClick"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true ;success_or_not
report_adjust_setting "#3: -g: ContextMenuGesture"
defaults write NSGlobalDomain ContextMenuGesture -int 1 ;success_or_not
report_adjust_setting "#4: -cH -g: c.a.trackpad.enableSecondaryClick"
defaults -currentHost write  NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true ;success_or_not
report_adjust_setting "#5: -cH -g: c.a.trackpad.trackpadCornerClickBehavior"
defaults -currentHost write  NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 0 ;success_or_not

report_action_taken "Point & Click: Tap to click"
report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: Clicking"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true ;success_or_not
report_adjust_setting "#2: c.a.driver.AppleBluetoothMultitouch.trackpad: Clicking"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true ;success_or_not
report_adjust_setting "#3: -cH -g: c.a.mouse.tapBehavior"
defaults -currentHost write  NSGlobalDomain com.apple.mouse.tapBehavior -int 1 ;success_or_not

report_adjust_setting "Scroll & Zoom: Natural scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true ;success_or_not

report_action_taken "Scroll & Zoom: Zoom in/out"
report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadPinch"
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true ;success_or_not
report_adjust_setting "#2: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadPinch"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -bool true ;success_or_not
report_adjust_setting "#3: -cH -g: c.a.trackpad.pinchGesture"
defaults -currentHost write  NSGlobalDomain com.apple.trackpad.pinchGesture -bool true ;success_or_not

report_action_taken "Scroll & Zoom: Smart Zoom"
report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadTwoFingerDoubleTapGesture"
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1 ;success_or_not
report_adjust_setting "#2: -cH -g: c.a.trackpad.twoFingerDoubleTapGesture"
defaults -currentHost write  NSGlobalDomain com.apple.trackpad.twoFingerDoubleTapGesture -int 1 ;success_or_not

report_action_taken "Scroll & Zoom: Rotate"
report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadRotate"
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true ;success_or_not
report_adjust_setting "#2: -cH -g: c.a.trackpad.rotateGesture"
defaults -currentHost write  NSGlobalDomain com.apple.trackpad.rotateGesture -bool true ;success_or_not

report_adjust_setting "More Gestures: Swipe between pages"
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true ;success_or_not

report_action_taken "More Gestures: Swipe between full-screen apps"
report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadFourFingerHorizSwipeGesture"
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 0 ;success_or_not
report_adjust_setting "#2: -cH -g: c.a.trackpad.fourFingerHorizSwipeGesture"
defaults -currentHost write  NSGlobalDomain com.apple.trackpad.fourFingerHorizSwipeGesture -int 0 ;success_or_not

report_action_taken "More Gestures: Notification Center"
report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadTwoFingerFromRightEdgeSwipeGesture"
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0 ;success_or_not
report_adjust_setting "#2: c.a.AppleMultitouchTrackpad: TrackpadTwoFingerFromRightEdgeSwipeGesture"
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0 ;success_or_not
report_adjust_setting "#3: -cH -g: c.a.trackpad.twoFingerFromRightEdgeSwipeGesture"
defaults -currentHost write  NSGlobalDomain com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture -int 0 ;success_or_not

report_action_taken "More Gestures: Mission Control"
report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadFourFingerVertSwipeGesture"
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2 ;success_or_not
report_adjust_setting "#2: c.a.AppleMultitouchTrackpad: TrackpadThreeFingerVertSwipeGesture"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0 ;success_or_not
report_adjust_setting "#3: c.a.dock: showMissionControlGestureEnabled"
defaults write com.apple.dock showMissionControlGestureEnabled -bool true ;success_or_not
report_adjust_setting "#4: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadFourFingerVertSwipeGesture"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2 ;success_or_not
report_adjust_setting "#5: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadThreeFingerVertSwipeGesture"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0 ;success_or_not
report_adjust_setting "#6: -cH -g: c.a.trackpad.fourFingerVertSwipeGesture"
defaults -currentHost write  NSGlobalDomain com.apple.trackpad.fourFingerVertSwipeGesture -int 2 ;success_or_not
report_adjust_setting "#7: -cH -g: c.a.trackpad.threeFingerVertSwipeGesture"
defaults -currentHost write  NSGlobalDomain com.apple.trackpad.threeFingerVertSwipeGesture -int 0 ;success_or_not

report_adjust_setting "More Gestures: App Exposé"
defaults write com.apple.dock showAppExposeGestureEnabled -bool false ;success_or_not

report_adjust_setting "More Gestures: Launchpad"
defaults write com.apple.dock showLaunchpadGestureEnabled -bool false ;success_or_not

report_action_taken "More Gestures: Show Desktop"
report_adjust_setting "#1: c.a.AppleMultitouchTrackpad: TrackpadFiveFingerPinchGesture"
defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2 ;success_or_not
report_adjust_setting "#2: c.a.AppleMultitouchTrackpad: TrackpadFourFingerPinchGesture"
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2 ;success_or_not
report_adjust_setting "#3: c.a.dock: showDesktopGestureEnabled"
defaults write com.apple.dock showDesktopGestureEnabled -bool true ;success_or_not
report_adjust_setting "#4: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadFiveFingerPinchGesture"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -int 2 ;success_or_not
report_adjust_setting "#5: c.a.driver.AppleBluetoothMultitouch.trackpad: TrackpadFourFingerPinchGesture"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -int 2 ;success_or_not
report_adjust_setting "#6: -cH -g: c.a.trackpad.fiveFingerPinchSwipeGesture"
defaults -currentHost write  NSGlobalDomain com.apple.trackpad.fiveFingerPinchSwipeGesture -int 2 ;success_or_not
report_adjust_setting "#7: -cH -g: c.a.trackpad.fourFingerPinchSwipeGesture"
defaults -currentHost write  NSGlobalDomain com.apple.trackpad.fourFingerPinchSwipeGesture -int 2 ;success_or_not

########## Other general interface
report_action_taken "Implement other general interface defaults"

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

# Double-click on titlebar behavior
# System Settings » Desktop & Dock » Dock » Double-click a window's title bar to: 
#  - "Fill" Fill
#  - "Maximize" =Zoom (default)
#  - "Minimize"
#  - "None" =Do Nothing
report_adjust_setting "Double-click on window’s title bar ⇒ Zoom (reinforces default)"
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Maximize";success_or_not

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

############### Keyboard-related defaults
report_action_taken "Implement keyboard-related defaults"

report_adjust_setting "Holding alpha key down pops up character-accent menu (rather than repeats). Reinforces default"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true;success_or_not

report_adjust_setting "Enable Keyboard Navigation (with Tab key)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2;success_or_not

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

# This needs to be tested on laptop
report_adjust_setting "Add Bluetooth to Control Center to access battery percentages of Bluetooth devices"
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true;success_or_not

############### Dock
report_action_taken "Implement Dock settings"

report_adjust_setting "Dock: Turn OFF automatic hide/show the Dock"
defaults write com.apple.dock autohide -bool false;success_or_not

report_adjust_setting "Dock: Turn on magnification effect when hovering over Dock"
defaults write com.apple.dock magnification -bool true;success_or_not

report_adjust_setting "Dock: Set size of magnified Dock icons"
defaults write com.apple.dock largesize -float 128;success_or_not

report_adjust_setting "Dock: Show indicator lights for open apps"
defaults write com.apple.dock show-process-indicators -bool true;success_or_not

report_adjust_setting "Make Dock icons of hidden apps translucent"
defaults write com.apple.Dock showhidden -bool true;success_or_not

report_adjust_setting "Dock: Enable two-finger scrolling on Dock icon to reveal thumbnails of all windows for that app"
defaults write com.apple.dock scroll-to-open -bool true;success_or_not

report_adjust_setting "Minimize app to Dock rather than to app’s Dock icon"
defaults write com.apple.dock minimize-to-application -bool false;success_or_not

# This is NOT working as of 7/2/2025
report_adjust_setting "Highlight the element of a grid-view Dock stack over which the cursor hovers"
defaults write com.apple.dock mouse-over-hilte-stack -bool true;success_or_not

############### Screen Capture
report_action_taken "Implement settings related to Screen Capture"

# NOTE: Setting the location should be separated from the other screen-capture preferences because this
#       would be user-specific
path_for_screen_capture_result="$HOME/Screenshots"
report_adjust_setting "1 of 7: Create screen-capture destination directory if necessary"
mkdir -p "$path_for_screen_capture_result";success_or_not

report_adjust_setting "2 of 7: Enforce appropriate permissions (700) on screen-capture directory"
# The 700 permissions are appropriate because this location in a user’s home directory.
chmod 700 "$path_for_screen_capture_result";success_or_not

report_adjust_setting "3 of 7: Assign path to screen-capture destination"
defaults write com.apple.screencapture location -string "$path_for_screen_capture_result";success_or_not
report_adjust_setting "4 of 7: Assign path to previous screen-capture destination"
defaults write com.apple.screencapture location-last -string "$path_for_screen_capture_result";success_or_not

report_adjust_setting "5 of 7: Specify that target is a file"
# Needed only when overriding an assignment to clipboard or an app (e.g., Mail, Preview)
defaults write com.apple.screencapture target -string "file";success_or_not

report_adjust_setting "6 of 7: Show floating thumbnail (reinforces default)"
defaults write com.apple.screencapture show-thumbnail -bool true;success_or_not

report_adjust_setting "7 of 7: Disable the drop shadow on screenshots"
defaults write com.apple.screencapture disable-shadow -bool "true";success_or_not

############### Mission Control/Spaces
report_action_taken "Implement settings related to Spaces (Mission Control)"

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

# Finder: Preferred window view: List view
report_adjust_setting "Set Finder preferred window view to List View"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv";success_or_not

# Finder: Show removable media (CDs, DVDs, etc.) on desktop
# This is the default. Included here to enforce the default if it is ever changed.
report_adjust_setting "Show removable media (CDs, DVDs, etc.) on desktop"
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true;success_or_not

# Finder: Show connected servers on desktop
report_adjust_setting "Show connected servers on desktop"
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true;success_or_not

# Search from current folder by default (rather than from "This Mac")
report_adjust_setting "Search from current folder by default (rather than from “This Mac”)"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf";success_or_not

# Finder: Unhide the ~/Library folder
report_adjust_setting "Unhide the ~/Library folder"
chflags nohidden ~/Library;success_or_not

# Finder: Expand certain panels of GetInfo windows
report_action_taken "Expand certain panels of GetInfo windows"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
        General -bool true \
        MetaData -bool true \
        Name -bool true \
        Comments -bool true \
        OpenWith -bool true \
        Preview -bool true \
        Privileges -bool true;success_or_not

# Finder: Do not sort folders first (reinforces the default)
report_action_taken "Do not sort folders first"
report_adjust_setting "1 of 2: Do not sort folders first in lists"
defaults write com.apple.finder _FXSortFoldersFirst -bool false;success_or_not
report_adjust_setting "1 of 2: Do not sort folders first on desktop"
defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool false;success_or_not

# Enable warning when changing extension (reinforces the default)
report_adjust_setting "Enable warning when changing extension (reinforces the default)"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool true;success_or_not

# Finder: Folder opens in tab (not new window) after ⌘-double-click. (reinforces default)
report_adjust_setting "⌘-double-click opens folder in new tab (not new window)"
defaults write com.apple.finder "FinderSpawnTab" -bool true;success_or_not


############### Time Machine
report_adjust_setting "Time Machine: Don’t prompt to use new disk as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true;success_or_not


############### DiskUtility
# Launch and quit DiskUtility in order that it will have preferences to modify.
report_action_taken "Launch and quit DiskUtility in order that it will have preferences to modify"
open -b com.apple.DiskUtility # By bundle ID (more reliable than `open -a` by display name)
sleep 2
osascript -e 'quit app "Disk Utility"';success_or_not

# DiskUtility: Show all devices in sidebar
report_adjust_setting "DiskUtility: Show all devices in sidebar"
defaults write com.apple.DiskUtility SidebarShowAllDevices -bool true;success_or_not

############### Terminal
report_action_taken "Give the Terminal a teeny bit of style, even though we will soon abandon it"
report_adjust_setting "Terminal: default for new windows: “Man Page”";success_or_not
defaults write com.apple.Terminal "Default Window Settings" -string "Man Page"
report_adjust_setting "Terminal: default for starting windows: “Man Page”";success_or_not
defaults write com.apple.Terminal "Startup Window Settings" -string "Man Page"

############### Text Edit
report_adjust_setting "Text Edit: Make plain text the default format"
defaults write com.apple.TextEdit RichText -bool false;success_or_not

############### Safari
report_action_taken "Implement Safari settings"

report_adjust_setting "Do NOT auto-open “safe” downloads"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false;success_or_not

report_adjust_setting "Never automatically open a website in a tab rather than a window"
defaults write com.apple.Safari TabCreationPolicy -int 0;success_or_not

report_adjust_setting "Show full website address in Smart Search field"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true;success_or_not

report_action_taken "Implement “Press Tab to highlight each item on a webpage”"
report_adjust_setting "1 of 2: WebKitPreferences.tabFocusesLinks"
defaults write com.apple.Safari WebKitPreferences.tabFocusesLinks -bool true;success_or_not
report_adjust_setting "2 of 2: WebKitTabToLinksPreferenceKey"
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true;success_or_not

report_action_taken "Show features for web developers"
report_adjust_setting "1 of 5: IncludeDevelopMenu"
defaults write com.apple.Safari IncludeDevelopMenu -bool true;success_or_not
report_adjust_setting "2 of 5: MobileDeviceRemoteXPCEnabled"
defaults write com.apple.Safari MobileDeviceRemoteXPCEnabled -bool true;success_or_not
report_adjust_setting "3 of 5: WebKitDeveloperExtrasEnabledPreferenceKey"
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true;success_or_not
report_adjust_setting "4 of 5: WebKitPreferences.developerExtrasEnabled"
defaults write com.apple.Safari WebKitPreferences.developerExtrasEnabled -bool true;success_or_not
report_adjust_setting "5 of 5: Safari.SandboxBroker: IncludeDevelopMenu"
defaults write com.apple.Safari.SandboxBroker ShowDevelopMenu -bool true;success_or_not

report_adjust_setting "Reveal internal debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true;success_or_not

############### Kill each affected app
report_action_taken "Force quit all apps/processes whose settings we just changed"
apps_to_kill=(
  "Finder"
  "SystemUIServer"
  "Dock"
  "Text Edit"
  "Safari"
  "cfprefsd"
)

for app_to_kill in "${apps_to_kill[@]}"; do
  report_about_to_kill_app "$app_to_kill"
  killall "$app_to_kill";success_or_not
done

report "It’s possible that some settings won’t take effect until after you logout or restart."

