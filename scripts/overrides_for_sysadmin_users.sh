# Source scripts/helpers.sh
source "${0:A:h}/helpers.sh"

function overrides_for_sysadmin_users() {
# Implements preferences for the sysadmin users (USER_VANILLA and USER_CONFIGURER) that diverge
# from preferences set for generic non-sysadmin users.
# Thus this function must be executed only after the preferences for generic non-sysadmin users are set.

report_action_taken "Adjust certain settings in a way appropriate for only SysAdmin accounts (but not for other accounts)"

# Finder: Show hard drives on desktop
report_adjust_setting "Show hard drives on desktop"
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true;success_or_not

# Finder: Show external drives on desktop (reinforces default)
report_adjust_setting "Show external drives on desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true;success_or_not
}
