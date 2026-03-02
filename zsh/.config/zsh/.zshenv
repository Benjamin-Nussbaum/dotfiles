#!/bin/sh

# https://wiki.archlinux.org/title/Zsh#Configuring_$PATH
typeset -U path PATH
path=(~/.local/bin $path)
export PATH


# General
export DOTFILES="$HOME/.dotfiles"
export SCRIPTS="$DOTFILES/scripts/.local/bin"
export USER="${USER:-$(whoami)}"
export GITUSER="Benjamin-Nussbaum"
export REPOS="$HOME/Repos"
export GHREPOS="$REPOS/github.com/$GITUSER"

export WORKREPOS=($REPOS/github.com/{KwiatLab,PublicQuantumNetwork})

typeset -U findpath FINDPATH
findpath=($GHREPOS $WORKREPOS $HOME ~/Documents/research ~/Documents/notes ~/Documents)
export findpath

typeset -U cdpath CDPATH
cdpath=(. .. $findpath)
export CDPATH

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
export ANDROID_HOME="$XDG_DATA_HOME"/android
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export GOBIN="$HOME/.local/bin"
export GOPATH="$XDG_DATA_HOME"/go
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export TEXMFVAR="$XDG_CACHE_HOME"/texlive/texmf-var
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export PYTHONSTARTUP="/etc/python/pythonrc"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
