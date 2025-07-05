# Source scripts/helpers.sh
source "${0:A:h}/helpers.sh"

# Source scripts/set_trackpad_settings.sh
source "${0:A:h}/set_trackpad_settings.sh"

function set_initial_user_level_settings() {

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

# ########## Trackpad
set_trackpad_settings

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

report_action_taken "Turn OFF: “Correct spelling automatically”"
report_adjust_setting "1 of 2: NSAutomaticSpellingCorrectionEnabled"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false;success_or_not
report_adjust_setting "2 of 2: WebAutomaticSpellingCorrectionEnabled"
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false;success_or_not

report_adjust_setting "Turn OFF: Capitalize words automatically"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false;success_or_not

# Turning off inline predictive text not currently chosen to be implemented, but could be:
# report_adjust_setting "Turn OFF: Show inline predictive text"
# defaults write NSGlobalDomain NSAutomaticInlinePredictionEnabled -bool false;success_or_not

# INTERESTING: Two different Macs (both running Sequoia macOS 15.5) disagree whether there is now a
# “Show suggested replies” option. My Mac Studio has it (which has been upgraded over time); 
# my pristine M1 Mac mini does not have it.

report_adjust_setting "Turn OFF: Add period with double-space"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false;success_or_not

report_action_taken "Turn OFF: Use smart quotes and dashes"
report_adjust_setting "1 of 2: I’ll supply the intelligence for my quotation marks, thank you!"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false;success_or_not
report_adjust_setting "2 of 2: Don’t automatically substitute dash/hyphen types"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false;success_or_not

############### Keyboard-related defaults
report_action_taken "Implement keyboard-related defaults"

report_adjust_setting "Holding alpha key down pops up character-accent menu (rather than repeats). Reinforces default"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true;success_or_not

report_adjust_setting "Enable Keyboard Navigation (with Tab key)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2;success_or_not

############### Menubar 

report_action_taken "Implement menubar-related settings"

# Always show Sound in menubar
report_adjust_setting "Always show Sound in menubar (not only when “active”)"
defaults -currentHost write com.apple.controlcenter sound -int 18;success_or_not

# Show battery percentage in menubar
report_adjust_setting "Show battery percentage in menubar"
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true;success_or_not

report_adjust_setting "Show time with seconds"
defaults write com.apple.menuextra.clock ShowSeconds -bool true;success_or_not

########## Show Fast User Switching in menubar as Account Name
report_action_taken "Show Fast User Switching in menubar only as Account Name"
report_adjust_setting "1 of 2: userMenuExtraStyle = 1 (Account Name)"
defaults write NSGlobalDomain userMenuExtraStyle -int 1;success_or_not
report_adjust_setting "2 of 2: UserSwitcher = 2 (menubar only)"
defaults -currentHost write com.apple.controlcenter UserSwitcher -int 2;success_or_not

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
# report_adjust_setting "Highlight the element of a grid-view Dock stack over which the cursor hovers"
# defaults write com.apple.dock mouse-over-hilte-stack -bool true;success_or_not

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

# Finder: Do not show hard drives on desktop
# This is the intended system for regular user (other than the sysadmin users USER_VANILLA and USER_CONFIGURER).
# To set preferences for these sysadmin users, a script should run following this scripts that inverts this boolean.
report_adjust_setting "Do not show hard drives on desktop"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false;success_or_not

# Finder: Do not show external drives on desktopdesktop
# This is the intended system for regular user (other than the sysadmin users USER_VANILLA and USER_CONFIGURER).
# To set preferences for these sysadmin users, a script should run following this scripts that inverts this boolean.
report_adjust_setting "Do not show external drives on desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false;success_or_not

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
report_adjust_setting "Expand certain panels of GetInfo windows"
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

report_adjust_setting "Show status bar"
defaults write com.apple.Safari ShowOverlayStatusBar -bool true;success_or_not

# report_adjust_setting "Show favorites bar (NOT WORKING)"
# WARNING: This is not working reliably
# defaults write com.apple.Safari "ShowFavoritesBar-v2" -bool true;success_or_not
# defaults write com.apple.Safari "ShowFavoritesBar" -bool true;success_or_not

report_adjust_setting "⌘-click opens a link in a new tab (reinforces default)"
defaults write com.apple.Safari CommandClickMakesTabs -bool true;success_or_not

report_adjust_setting "Do NOT make a new tab/window active"
defaults write com.apple.Safari OpenNewTabsInFront -bool false;success_or_not

report_action_taken "Turn on: Prevent cross-site tracking (reinforces default)"
report_adjust_setting "1 of 3: BlockStoragePolicy"
defaults write com.apple.Safari BlockStoragePolicy -int 2;success_or_not
report_adjust_setting "2 of 3: WebKitPreferences.storageBlockingPolicy"
defaults write com.apple.Safari WebKitPreferences.storageBlockingPolicy -int 1;success_or_not
report_adjust_setting "1 of 3: WebKitStorageBlockingPolicy"
defaults write com.apple.Safari WebKitStorageBlockingPolicy -int 1;success_or_not

report_action_taken "Warn if visit a fraudulent site"
report_adjust_setting "1 of 2: WarnAboutFraudulentWebsites"
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true;success_or_not
report_adjust_setting "2 of 2: com.apple.Safari.SafeBrowsing » SafeBrowsingEnabled"
defaults write com.apple.Safari.SafeBrowsing SafeBrowsingEnabled -bool true;success_or_not

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

}
