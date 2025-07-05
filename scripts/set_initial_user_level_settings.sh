# Source scripts/helpers.sh
source "${0:A:h}/helpers.sh"

# Source scripts/set_trackpad_settings.sh
source "${0:A:h}/set_trackpad_settings.sh"

# Source scripts/set_finder_settings.sh
source "${0:A:h}/set_finder_settings.sh"

# Source scripts/set_safari_settings.sh
source "${0:A:h}/set_safari_settings.sh"

# Source scripts/set_auto_correction_suggestion_settings.sh
source "${0:A:h}/set_auto_correction_suggestion_settings.sh"

# Source scripts/set_screen_capture_settings.sh
source "${0:A:h}/set_screen_capture_settings.sh"

# Source scripts/set_terminal_settings.sh
source "${0:A:h}/set_terminal_settings.sh"

# Source scripts/set_general_dock_settings.sh
source "${0:A:h}/set_general_dock_settings.sh"

# Source scripts/set_diskutility_settings.sh
source "${0:A:h}/set_diskutility_settings.sh"

function set_initial_user_level_settings() {

############### Enable app-state persistence
set_app_state_persistence

# report_action_taken "Implement app-state persistence"
# 
# report_adjust_setting "1 of 3: loginwindow: TALLogoutSavesState: true"
# defaults write com.apple.loginwindow TALLogoutSavesState -bool true;success_or_not
# report_adjust_setting "2 of 3: loginwindow: LoginwindowLaunchesRelaunchApps: true"
# defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool true;success_or_not
# report_adjust_setting "3 of 3: NSGlobalDomain: NSQuitAlwaysKeepsWindows: true"
# defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true;success_or_not

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

# ########## Stop intrusive/arrogant “corrections”
set_auto_correction_suggestion_settings

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
set_general_dock_settings

############### Screen Capture
set_screen_capture_settings

############### Mission Control/Spaces
report_action_taken "Implement settings related to Spaces (Mission Control)"

report_adjust_setting "Spaces: Don’t rearrange based on most-recent use"
defaults write com.apple.dock mru-spaces -bool false;success_or_not

report_adjust_setting "Spaces span all display (no separate space for each monitor)"
defaults write com.apple.spaces "spans-displays" -bool "true";success_or_not

report_adjust_setting "Do not jump to a new space when switching applications"
defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool false;success_or_not

############### Finder
set_finder_settings

############### Time Machine
report_adjust_setting "Time Machine: Don’t prompt to use new disk as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true;success_or_not

############### DiskUtility
set_diskutility_settings

############### Terminal
set_terminal_settings

############### Text Edit
report_adjust_setting "Text Edit: Make plain text the default format"
defaults write com.apple.TextEdit RichText -bool false;success_or_not

############### Safari
set_safari_settings

}
