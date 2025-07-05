#!/usr/bin/env zsh

set -euo pipefail

# Source scripts/helpers.sh
source "${0:A:h}/helpers.sh"

# Source scripts/get_loginwindow_message.sh
source "${0:A:h}/get_loginwindow_message.sh"

# Source scripts/set_initial_systemwide_settings.sh
source "${0:A:h}/set_initial_systemwide_settings.sh"

# Source scripts/overrides_for_sysadmin_users.sh
source "${0:A:h}/overrides_for_sysadmin_users.sh"

# Source scripts/set_initial_user_level_settings.sh
source "${0:A:h}/set_initial_user_level_settings.sh"

# Implements selected `defaults` command for the admin accounts, to remove the 
# biggest annoyances ASAP during bootstrapping.
#
# Because this is for bootstrapping, any settings that act upon, or require, software not pre-installed on the Mac, must wait.

# report_action_taken "Message"
# report_adjust_setting "Message"

# Set initial system-wide settings (requires sudo)
# set_initial_systemwide_settings

# Set initial user-level settings
set_initial_user_level_settings

############### Override certain settings in a way appropriate for only SysAdmin accounts
overrides_for_sysadmin_users

############### Kill each affected app
report_action_taken "Force quit all apps/processes whose settings we just changed"
apps_to_kill=(
  "Finder"
  "SystemUIServer"
  "Dock"
  "Text Edit"
  "Safari"
  "cfprefsd"
)

for app_to_kill in "${apps_to_kill[@]}"; do
  report_about_to_kill_app "$app_to_kill"
  killall "$app_to_kill";success_or_not
done

report "It’s possible that some settings won’t take effect until after you logout or restart."



