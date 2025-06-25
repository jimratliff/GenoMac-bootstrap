better-prefs:
	zsh scripts/helpers.sh
	zsh scripts/better_prefs.sh

install-1password:
	brew install --cask 1password
	brew install 1password-cli
	open -a 1Password
