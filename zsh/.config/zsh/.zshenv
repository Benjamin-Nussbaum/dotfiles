#!/bin/sh

# https://wiki.archlinux.org/title/Zsh#Configuring_$PATH
typeset -U path PATH
path=(~/.local/bin $path)
export PATH

# Programs
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="librewolf"

# XDG user directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# $HOME cleanup
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
