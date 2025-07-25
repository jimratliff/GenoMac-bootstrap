# This file assumes GENOMAC_BOOTSTRAP_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_BOOTSTRAP_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_BOOTSTRAP_HELPER_DIR is not set. Please source the main bootstrap script first."
  return 1
fi

source "${GENOMAC_BOOTSTRAP_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################

function set_general_interface_settings() {

report_start_phase_standard
report_action_taken "Set general interface settings"

# Show scroll bars always (not only when scrolling)
report_adjust_setting "Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always";success_or_not

# Override change to clicking-on-desktop behavior
# Desktop & Dock » Desktop & Stage Manager » Click wallpaper to reveal desktop » Only in Stage Manager
report_adjust_setting "Reverse obnoxious default that revealed desktop anytime you clicked on the desktop"
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false;success_or_not

# Window tabbing mode
report_adjust_setting "AppleWindowTabbingMode: manual ⇒ Window should display as tabs according to window’s tabbing mode”"
defaults write NSGlobalDomain AppleWindowTabbingMode -string "manual";success_or_not

# Double-click on titlebar behavior
# System Settings » Desktop & Dock » Dock » Double-click a window's title bar to: 
#  - "Fill" Fill
#  - "Maximize" =Zoom (default)
#  - "Minimize"
#  - "None" =Do Nothing
report_adjust_setting "Double-click on window’s title bar ⇒ Zoom (reinforces default)"
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Maximize";success_or_not

# By default, save to disk, not to iCloud
report_adjust_setting "By default, save to disk, not to iCloud"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false;success_or_not

############### Expand certain dialog boxes by default
report_action_taken "Expand “Save As…” dialog boxes"
report_adjust_setting "1 of 2: NSNavPanelExpandedStateForSaveMode"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true;success_or_not
report_adjust_setting "2 of 2: NSNavPanelExpandedStateForSaveMode2"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true;success_or_not

report_action_taken "Expand print dialog boxes"
report_adjust_setting "1 of 2: PMPrintingExpandedStateForPrint"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true;success_or_not
report_adjust_setting "2 of 2: PMPrintingExpandedStateForPrint2"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true;success_or_not

report_end_phase_standard

}
