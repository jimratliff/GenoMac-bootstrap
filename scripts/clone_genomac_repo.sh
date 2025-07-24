#!/bin/zsh

# Fail early on unset variables or command failure
set -euo pipefail

# Resolve this script's directory (even if sourced)
this_script_path="${(%):-%N}"
this_script_dir="${this_script_path:A:h}"

# Specify the directory in which the `helpers.sh` file lives.
# E.g., when `helpers.sh` lives at the same level as this script:
# GENOMAC_BOOTSTRAP_HELPER_DIR="${this_script_dir}"
GENOMAC_BOOTSTRAP_HELPER_DIR="${this_script_dir}"

source "${GENOMAC_BOOTSTRAP_HELPER_DIR}/helpers.sh"

############################## BEGIN SCRIPT PROPER ##############################
function clone_genomac_repo() {
  report_start_phase_standard

  local target_dir="$HOME/genomac"
  local repo_url="git@github.com:jimratliff/GenoMac.git"

  report_action_taken "Ensuring target directory exists: $target_dir"
  mkdir -p "$target_dir"; success_or_not

  report_action_taken "Changing directory to: $target_dir"
  cd "$target_dir"; success_or_not

  report_action_taken "Cloning repo: $repo_url"
  git clone "$repo_url" .; success_or_not

  report_end_phase_standard
}

function main() {
  clone_genomac_repo
}

main
