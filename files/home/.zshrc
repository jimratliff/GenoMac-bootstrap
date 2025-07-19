# Automatically use 1Password SSH agent if present
sock="$HOME/.1password/agent.sock"
if [[ -S "$sock" ]]; then
  export SSH_AUTH_SOCK="$sock"
fi
