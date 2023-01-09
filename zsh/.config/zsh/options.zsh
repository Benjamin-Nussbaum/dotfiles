#!/bin/sh

# Completions
autoload -Uz compinit
zstyle ':completion:*' menu yes select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
_comp_options+=(globdots)               # Include hidden files.
zle_highlight=('paste:none')
for dump in "${ZDOTDIR:-$HOME}/.zcompdump"(N.mh+24); do
  compinit
done
compinit -C

# Options (see man zshoptions(1))

unsetopt BEEP                   # Disable beep on error.
stty stop undef		              # Disable ctrl-s to freeze terminal.
setopt AUTO_CD                  # Automatically cd into typed directory.
# setopt GLOB_DOTS                # Do not require a leading `.' in a filename to be matched explicitly.
setopt MENU_COMPLETE            # Different behavior for ambiguous completions; overrides AUTO_MENU.
setopt EXTENDED_GLOB            # Use '#', '~', and '^' for filename generation.
setopt INTERACTIVE_COMMENTS     # Allow comments even in interactive shells.

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt EXTENDED_HISTORY         # Write to $HISTFILE in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY_TIME  # Write to $HISTFILE when the command finishes, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicate entries first when trimming history.
# setopt HIST_IGNORE_DUPS         # Don't record an entry that was just recorded again.
# setopt HIST_IGNORE_ALL_DUPS     # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS        # Do not display a line previously found.
setopt HIST_IGNORE_SPACE        # Don't record an entry starting with a space.
# setopt HIST_SAVE_NO_DUPS        # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY              # Don't execute immediately upon history expansion.

# Keybinds

# Edit in a buffer with <C-e>
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^e' edit-command-line
# Make delete key act as expected
bindkey '\e[3~' delete-char
bindkey -M vicmd '\e[3~' vi-delete-char
bindkey -M visual '\e[3~' vi-delete

bindkey	'^ ' autosuggest-accept
bindkey -s '^x' '^usource ${ZDOTDIR:-$HOME}/.zshrc\n'
