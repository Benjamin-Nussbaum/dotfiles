#!/bin/sh

# sudo not required for some system commands
for command in mount umount sv pacman updatedb su shutdown poweroff reboot ; do
  alias $command="sudo $command"
done; unset command

# Verbosity and common options
alias \
  cp="cp -iv" \
  mv="mv -iv" \
  rm="rm -vI" \
  mkdir="mkdir -pv" \
  yt="yt-dlp --embed-metadata -i" \
  yta="yt -x -f bestaudio/best" \
  ffmpeg="ffmpeg -hide_banner" \

# Add color
alias \
  ls="ls -hN --color=auto --group-directories-first" \
  grep="grep --color=auto" \
  ip="ip -color=auto" \

# Git
alias \
  g="git" \
  gc="git clone" \

# Other
alias \
  ka="killall" \
  p="paru" \

[ $TERM = "xterm-kitty" ] && alias \
  ssh="kitty +kitten ssh"
