# This file assumes GENOMAC_BOOTSTRAP_HELPER_DIR is already set in the current shell
# to the absolute path of the directory containing helpers.sh.
# That variable must be defined before this file is sourced.

if [[ -z "${GENOMAC_BOOTSTRAP_HELPER_DIR:-}" ]]; then
  echo "❌ GENOMAC_BOOTSTRAP_HELPER_DIR is not set. Please source the main bootstrap script first."
  return 1
fi

source "${GENOMAC_BOOTSTRAP_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################


function get_Mac_names() {
############### Get and optionally set Mac computer names
report_start_phase_standard
report_action_taken "Get and optionally set Mac ComputerName and LocalHostName"

# Display current ComputerName to user, offering opportunity to change it.
# Whether ComputerName is changed or remains the same, a new LocalHostName is computed from ComputerName:
#   - Normalized/sanitized by stripping leading/trailing spaces

# Get current ComputerName
# Note: `systemsetup -getcomputername` outputs ComputerName as the text string: 'Computer Name: MyComputerName'
#       The following `sed` command converts that prefix to an empty string.
current_name=$(sudo systemsetup -getcomputername 2>/dev/null | sed 's/^Computer Name: //')
echo "Current ComputerName: \"$current_name\""

# Ask whether to change the ComputerName
while true; do
  echo -n "Would you like to change the ComputerName? (y/n): "
  read choice
  if [[ "$choice" =~ ^[YyNn]$ ]]; then
    break
  else
    echo "Invalid response. Please enter “y” or “n”."
  fi
done

if [[ "$choice" =~ ^[Yy]$ ]]; then
while true; do
  echo -n "Enter desired ComputerName: "
  read new_name_raw

  # Strip leading/trailing whitespace
  new_name=$(echo "$new_name_raw" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  echo "You entered: \"$new_name\""
  echo -n "Is this correct? (y/n): "
  read confirmation

  if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    report_action_taken 'Assigning ComputerName'
    sudo systemsetup -setcomputername "$new_name" 2> >(grep -v '### Error:-99' >&2); success_or_not
    break
  fi
done
  final_name="$new_name"
else
  echo "Keeping existing ComputerName."
  final_name="$current_name"
fi

# Derive LocalHostName by sanitizing ComputerName
# - Replace all whitespace with hyphens
# - Remove all but alphanumerics and hyphens
# - Remove leading/trailing hyphens (which also removes any originally leading/trailing whitespace)

sanitized_name=$(echo "$final_name" \
  | tr '[:space:]' '-' \
  | tr -cd '[:alnum:]-' \
  | sed 's/^-*//;s/-*$//')

# trimmed_name=$(echo "$final_name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
# sanitized_name=$(echo "$trimmed_name" | tr '[:space:]' '-' | tr -cd '[:alnum:]-' | sed 's/^-*//;s/-*$//')
echo "Sanitized LocalHostName: \"$sanitized_name\""
sudo scutil --set LocalHostName "$sanitized_name"; success_or_not

# Display final names
echo ""
report_action_taken "Final name settings:"
printf "ComputerName:   %s\n" "$(sudo scutil --get ComputerName 2>/dev/null || echo "(not set)")"
printf "LocalHostName:  %s\n" "$(sudo scutil --get LocalHostName 2>/dev/null || echo "(not set)")"
printf "HostName:       %s\n" "$(sudo scutil --get HostName 2>/dev/null || echo "(not set)")"

report_end_phase_standard

}
