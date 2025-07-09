#!/bin/sh
# Runs on login shell only.

# Start graphical server on tty1 if not already running.
[ "$(tty)" = "/dev/tty1" ] && ! pidof -q Hyprland && exec "/usr/bin/Hyprland"
