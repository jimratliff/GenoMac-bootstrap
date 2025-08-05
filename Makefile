configure-homebrew-path:
	echo >> ~/.zprofile
	echo '# Set up Homebrew in PATH (added by GenoMac bootstrap)' >> ~/.zprofile
	echo 'eval "$$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

better-prefs:
	zsh scripts/better_prefs.sh

install-1password:
	brew install --cask 1password
	brew install --cask 1password-cli
	open -a 1Password

deploy-ssh-agent-dotfiles:
	zsh scripts/install_ssh_agent_dotfiles.sh

verify-ssh-agent:
	zsh scripts/verify_ssh_agent_setup.sh

clone-genomac:
	zsh scripts/clone_genomac_repo.sh
