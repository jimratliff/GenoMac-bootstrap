# Source scripts/helpers.sh
source "${0:A:h}/helpers.sh"

function set_app_state_persistence() {

report_action_taken "Implement app-state persistence"

report_adjust_setting "1 of 3: loginwindow: TALLogoutSavesState: true"
defaults write com.apple.loginwindow TALLogoutSavesState -bool true;success_or_not
report_adjust_setting "2 of 3: loginwindow: LoginwindowLaunchesRelaunchApps: true"
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool true;success_or_not
report_adjust_setting "3 of 3: NSGlobalDomain: NSQuitAlwaysKeepsWindows: true"
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true;success_or_not

}
