# Source scripts/helpers.sh
source "${0:A:h}/helpers.sh"

function set_general_dock_settings() {

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

}
