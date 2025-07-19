better-prefs:
	zsh scripts/better_prefs.sh

install-1password:
	brew install --cask 1password
	brew install 1password-cli
	open -a 1Password

deploy-ssh-agent-dotfiles:
	zsh scripts/install_ssh_agent_dotfiles.sh
