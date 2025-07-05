# Source scripts/helpers.sh
source "${0:A:h}/helpers.sh"

function set_screen_capture_settings() {

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

}
