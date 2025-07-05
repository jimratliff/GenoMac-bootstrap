# Source scripts/helpers.sh
source "${0:A:h}/helpers.sh"

function set_diskutility_settings() {

# Launch and quit DiskUtility in order that it will have preferences to modify.
report_action_taken "Launch and quit DiskUtility in order that it will have preferences to modify"
open -b com.apple.DiskUtility # By bundle ID (more reliable than `open -a` by display name)
sleep 2
osascript -e 'quit app "Disk Utility"';success_or_not

# DiskUtility: Show all devices in sidebar
report_adjust_setting "DiskUtility: Show all devices in sidebar"
defaults write com.apple.DiskUtility SidebarShowAllDevices -bool true;success_or_not

}
