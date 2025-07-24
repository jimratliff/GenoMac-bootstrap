#!/bin/zsh

# Fail early on unset variables or command failure
set -euo pipefail

# Resolve this script’s directory
this_script_path="${(%):-%N}"
this_script_dir="${this_script_path:A:h}"

# Specify the directory in which the `helpers.sh` file lives.
# E.g., when `helpers.sh` lives at the same level as this script:
# GENOMAC_BOOTSTRAP_HELPER_DIR="${this_script_dir}"
GENOMAC_BOOTSTRAP_HELPER_DIR="${this_script_dir}"

source "${GENOMAC_BOOTSTRAP_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################
function verify_ssh_agent_setup() {
report_start_phase_standard
if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
  report_error "SSH_AUTH_SOCK is not set. Failed: SSH agent not configured"
  report_end_phase_standard
  exit 1
fi

# Try to authenticate to GitHub via SSH
report_action_taken "Testing SSH auth with: ssh -T git@github.com"

ssh_output=$(ssh -T git@github.com 2>&1) || true  # Don't let failure abort script

if [[ "$ssh_output" == *"successfully authenticated"* ]]; then
  print -r -- "${SYMBOL_SUCCESS}SSH authentication with GitHub succeeded"
  report "Verified: SSH agent is working"
  report_end_phase_standard
  exit 0
else
  report_warning "SSH authentication failed. Output:"
  print -r -- "$ssh_output"
  print -r -- "${SYMBOL_FAILURE}SSH authentication with GitHub failed"
  report_end_phase_standard
  exit 1
fi

}
