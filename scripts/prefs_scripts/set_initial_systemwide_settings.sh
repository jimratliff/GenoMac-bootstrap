# This file assumes GENOMAC_BOOTSTRAP_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_BOOTSTRAP_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_BOOTSTRAP_HELPER_DIR is not set. Please source the main bootstrap script first."
  return 1
fi

if [[ -z "${BETTER_PREFS_COMPONENTS_DIR:-}" ]]; then
  echo "❌ BETTER_PREFS_COMPONENTS_DIR is not set. Please source the main bootstrap script first."
  return 1
fi

source "${GENOMAC_BOOTSTRAP_HELPER_DIR}/helpers.sh"

source "${BETTER_PREFS_COMPONENTS_DIR}/get_Mac_names.sh"

source "${BETTER_PREFS_COMPONENTS_DIR}/get_loginwindow_message.sh"

function set_initial_systemwide_settings() {
# Makes system-wide settings, requiring sudo, to be run from USER_CONFIGURER.

report_action_taken "Begin commands that require 'sudo'"
keep_sudo_alive

# Get ComputerName and LocalHostName
get_Mac_names

# Get login-window message
get_loginwindow_message

# Configure application firewall
report_action_taken "Configure application firewall"
report_adjust_setting "1 of 2: Enable application firewall"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on;success_or_not
report_adjust_setting "2 of 2: Enable Stealth Mode"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on;success_or_not

# Configure system-wide settings controlling software-update behavior
report_action_taken "Implement system-wide settings controlling how macOS and MAS-app software updates occur"

report_adjust_setting "Automatically check for updates (both macOS and MAS apps)"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true;success_or_not

report_adjust_setting "Download updates when available"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true;success_or_not

report_adjust_setting "Do NOT automatically update macOS"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool false;success_or_not

report_adjust_setting "Automatically update applications from Mac App Store"
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true;success_or_not

# Display additional information on login window
report_adjust_setting "Display additional info (IP address, hostname, OS version) when clicking on the clock digits of the login window"
# Requires restart.
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName;success_or_not

report_action_taken "End commands that require 'sudo'"

}
