#!/usr/bin/env zsh

# Implements selected `defaults` and related commands for the SysAdmin accounts (USER_VANILLA, USER_CONFIGURER), 
# to remove at least the biggest annoyances ASAP during bootstrapping.
#
# Because this is for bootstrapping, any settings that act upon, or require, software not pre-installed on the 
# Mac, must wait.

set -euo pipefail

# Resolve the directory in which this file lives (even when sourced)
this_script_path="${(%):-%N}"
this_script_dir="${this_script_path:A:h}"

# Specify the directory in which the `helpers.sh` file lives.
# E.g., when `helpers.sh` lives at the same level as this script:
# GENOMAC_BOOTSTRAP_HELPER_DIR="${this_script_dir}"
GENOMAC_BOOTSTRAP_HELPER_DIR="${this_script_dir}"

# Specify the directory in which the file(s) containing the preferences-related functions called by this script
# lives.
# E.g., the function `overrides_for_sysadmin_users` is supplied by a file `overrides_for_sysadmin_users.sh`. If
# `overrides_for_sysadmin_users.sh` resides at the same level as this script:
# BETTER_PREFS_COMPONENTS_DIR="${this_script_dir}"
BETTER_PREFS_COMPONENTS_DIR="${this_script_dir}/prefs_scripts"

# Print assigned paths for diagnostic purposes
printf "\n📂 Path diagnostics:\n"
printf "this_script_dir:              %s\n" "$this_script_dir"
printf "GENOMAC_BOOTSTRAP_HELPER_DIR: %s\n" "$GENOMAC_BOOTSTRAP_HELPER_DIR"
printf "BETTER_PREFS_COMPONENTS_DIR:  %s\n\n" "$BETTER_PREFS_COMPONENTS_DIR"

source "${GENOMAC_BOOTSTRAP_HELPER_DIR}/helpers.sh"

source "${BETTER_PREFS_COMPONENTS_DIR}/set_initial_systemwide_settings.sh"
source "${BETTER_PREFS_COMPONENTS_DIR}/set_initial_user_level_settings.sh"
source "${BETTER_PREFS_COMPONENTS_DIR}/overrides_for_sysadmin_users.sh"

# Set initial system-wide settings (requires sudo)
set_initial_systemwide_settings

# Set initial user-level settings
set_initial_user_level_settings

# Override certain settings in a way appropriate for only SysAdmin accounts
overrides_for_sysadmin_users

# Kill each app affected by `defaults` commands in the prior functions
# (App-killing deferred here to avoid redundantly killing the same app multiple times.)
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
  killall "$app_to_kill" 2>/dev/null || true
  success_or_not
done

report "It’s possible that some settings won’t take effect until after you logout or restart."



