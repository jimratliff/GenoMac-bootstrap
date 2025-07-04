# Prevent multiple sourcing
if [[ -n "${__already_loaded_genomac_bootstrap_helpers_sh:-}" ]]; then return 0; fi
__already_loaded_genomac_bootstrap_helpers_sh=1

# ... rest of helpers.sh ...

# Set up and assign colors
ESC_SEQ="\033["

COLOR_RESET="${ESC_SEQ}0m"

COLOR_BLACK="${ESC_SEQ}30;01m"
COLOR_RED="${ESC_SEQ}31;01m"
COLOR_GREEN="${ESC_SEQ}32;01m"
COLOR_YELLOW="${ESC_SEQ}33;01m"
COLOR_BLUE="${ESC_SEQ}34;01m"
COLOR_MAGENTA="${ESC_SEQ}35;01m"
COLOR_CYAN="${ESC_SEQ}36;01m"
COLOR_WHITE="${ESC_SEQ}37;01m"

COLOR_REPORT="$COLOR_BLUE"
COLOR_ADJUST_SETTING="$COLOR_CYAN"
COLOR_ACTION_TAKEN="$COLOR_GREEN"
COLOR_WARNING="$COLOR_YELLOW"
COLOR_KILLED="$COLOR_RED"

SYMBOL_SUCCESS="✅ "
SYMBOL_FAILURE="❌ "
SYMBOL_ADJUST_SETTING="⚙️  "
SYMBOL_KILLED="☠️ "
SYMBOL_ACTION_TAKEN="🪚 "
SYMBOL_WARNING="🚨 "

# Example usage
# Each %b and %s maps to a successive argument to printf
# printf "%b[ok]%b %s\n" "$COLOR_GREEN" "$COLOR_RESET" "some message"

#function success() {
#  # Terminates a line of output with the OK symbol ($SYMBOL_OK)
#  printf " ${SYMBOL_SUCCESS}\n"
#}

function success_or_not() {
  if [[ $? -eq 0 ]]; then
    printf " ${SYMBOL_SUCCESS}\n"
  else
    printf "\n${SYMBOL_FAILURE}\n"
  fi
}

function report() {
  # Output supplied line of text in a distinctive color.
  printf "%b%s%b\n" "$COLOR_REPORT" "$1" "$COLOR_RESET"
}

function report_adjust_setting() {
  # Output supplied line of text in a distinctive color, prefaced by "$SYMBOL_ADJUST_SETTING.
  # It is intentional to NOT have a newline. This will be supplied by success().
  printf "%b%s%s%b" "$COLOR_ADJUST_SETTING" "$SYMBOL_ADJUST_SETTING" "$1" "$COLOR_RESET"
}

function report_about_to_kill_app() {
  # Takes `app` as argument
  # Outputs message that the app was killed.
  printf "%b%s %s is being killed (if necessary) %b" "$COLOR_KILLED" "$SYMBOL_KILLED" "$1" "$COLOR_RESET"
}

function report_action_taken() {
  # Output supplied line of text in a distinctive color, prefaced by "$SYMBOL_ADJUST_SETTING.
  printf "%b%s%s%b\n" "$COLOR_ACTION_TAKEN" "$SYMBOL_ACTION_TAKEN" "$1" "$COLOR_RESET"
}
