#!/bin/sh

# Ghostty auto-config hijacks ZDOTDIR. Here is the workaround.
[[ $TERM = "xterm-ghostty" ]] && [[ -d $GHOSTTY_RESOURCES_DIR ]] && source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"

# Use https://github.com/zap-zsh/zap to manage plugins
[[ -f "$HOME/.local/share/zap/zap.zsh" ]] && source "$HOME/.local/share/zap/zap.zsh"

# source
plug "$ZDOTDIR/aliases.zsh"
plug "$ZDOTDIR/options.zsh"
plug "$ZDOTDIR/prompt.zsh"

# plugins
plug "zap-zsh/vim"
plug "zap-zsh/fzf"
plug "Aloxaf/fzf-tab"
plug "Freed-Wu/fzf-tab-source"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "wintermi/zsh-bob"

# Ensure SSH agent is running with appropriate keys
if [[ $(ps ax | grep -F ssh-agent | wc -l ) -gt 0 ]]; then
  # echo "ssh-agent is already running"
else
  eval $(ssh-agent -s)
  if [[ "$(ssh-add -l)" = "The agent has no identities." ]] ; then
    ssh-add ~/.ssh/id_rsa
    ssh-add ~/.ssh/github/id_ed25519
  fi

  # Don't leave extra agents around: kill it on exit.
  # trap "ssh-agent -k" exit
fi
