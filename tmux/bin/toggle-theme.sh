#!/usr/bin/env sh
#
# Toggle the current window (all panes) between light and dark themes.
set -e

dark_status_style='fg=white,bg=#393836'
light_status_style='fg=black,bg=#e4d794'

current_status_style=$(tmux show -Av status-style)

case $current_status_style in
  $dark_status_style|'default')
    # Change to the alternate window style.
    tmux set status-style $light_status_style
    tmux set pane-border-style $light_status_style
    tmux set pane-active-border-style $light_status_style
    ;;
  *)
    # Change back to the default window style.
    tmux set status-style $dark_status_style
    tmux set pane-border-style $dark_status_style
    tmux set pane-active-border-style $dark_status_style
    ;;
esac
