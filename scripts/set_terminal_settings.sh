# Source scripts/helpers.sh
source "${0:A:h}/helpers.sh"

function set_terminal_settings() {

report_action_taken "Give the Terminal a teeny bit of style, even though we will soon abandon it"
report_adjust_setting "Terminal: default for new windows: “Man Page”";success_or_not
defaults write com.apple.Terminal "Default Window Settings" -string "Man Page"
report_adjust_setting "Terminal: default for starting windows: “Man Page”";success_or_not
defaults write com.apple.Terminal "Startup Window Settings" -string "Man Page"

}
