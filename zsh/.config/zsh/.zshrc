#!/bin/sh

# Use https://github.com/zap-zsh/zap to manage plugins
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"

# source
plug "$ZDOTDIR/aliases.zsh"
plug "$ZDOTDIR/options.zsh"
plug "$ZDOTDIR/prompt.zsh"

# plugins
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/vim"
plug "zsh-users/zsh-syntax-highlighting"
