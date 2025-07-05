
# Source scripts/helpers.sh
source "${0:A:h}/helpers.sh"

function get_loginwindow_message() {
############### Get login-window message
# Displays any preexisting login-window message
# Asks user whether they want to supply new text
#   - I.e., if not, existing text is retained or, if none existing, there will be no loginwindow message.
# If user wants to supply a message, the user is queried for the text and iterates until confirmed.

report_action_taken "Set login-window message"

# Check for existing login text
preexisting_text=$(defaults read /Library/Preferences/com.apple.loginwindow LoginwindowText 2>/dev/null || true)

if [[ -n "$preexisting_text" ]]; then
  echo "Preexisting login-window text: \"$preexisting_text\""
else
  echo "No existing login-window text."
fi

# Ask whether to set new login text
while true; do
  echo -n "Would you like to set (or clear) login-window text? (y/n): "
  read choice
  if [[ "$choice" =~ ^[YyNn]$ ]]; then
    break
  else
    echo "Invalid response. Please enter “y” or “n”."
  fi
done

if [[ "$choice" =~ ^[Yy]$ ]]; then
  while true; do
    echo -n "Enter desired login-window message (leave blank for none): "
    read user_input

    echo "You entered: \"$user_input\""
    echo -n "Is this correct? (y/n): "
    read confirmation

    if [[ "$confirmation" =~ ^[Yy]$ ]]; then
      break
    fi
  done

  echo "Final choice: \"$user_input\""
  if [[ -n "$user_input" ]]; then
    sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText -string "$user_input"; success_or_not
  else
    sudo defaults delete /Library/Preferences/com.apple.loginwindow LoginwindowText 2>/dev/null; success_or_not
  fi
else
  echo "No changes made to login-window text."
fi

}
