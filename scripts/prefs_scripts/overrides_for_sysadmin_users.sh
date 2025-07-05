# This file assumes GENOMAC_BOOTSTRAP_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_BOOTSTRAP_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_BOOTSTRAP_HELPER_DIR is not set. Please source the main bootstrap script first."
  return 1
fi

source "${GENOMAC_BOOTSTRAP_HELPER_DIR}/helpers.sh"

function overrides_for_sysadmin_users() {
# Implements preferences for the sysadmin users (USER_VANILLA and USER_CONFIGURER) that diverge
# from preferences set for generic non-sysadmin users.
# Thus this function must be executed only after the preferences for generic non-sysadmin users are set.

report_action_taken "Overriding certain settings in a way appropriate for only SysAdmin accounts (but not for other accounts)"

# Finder: Show hard drives on desktop
report_adjust_setting "Show hard drives on desktop"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true;success_or_not

# Finder: Show external drives on desktop (reinforces default)
report_adjust_setting "Show external drives on desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true;success_or_not

report_action_taken "Sysadmin overrides completed. Please relaunch Finder."

# TODO: This winds up killing Finder twice. A better solutions should be sought, where each script
# appends to a list of apps that need to be killed.

# report_about_to_kill_app "Finder"
# killall "Finder";success_or_not

}
