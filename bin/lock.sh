#!/usr/bin/env sh
betterlockscreen_path="$HOME/src/betterlockscreen/betterlockscreen"

i3lock_wrapper() {
  i3lock -u --ignore-empty-password --color=071715 && sleep 1
}

betterlockscreen_wrapper() {
  $betterlockscreen_path --lock dimblur -- -u
}

lock_lock() {
  if [ -x $betterlockscreen_path ]; then
    betterlockscreen_wrapper
  else
    i3lock_wrapper
  fi
}

lock_hibernate() {
  if [ -x $betterlockscreen_path ]; then
    betterlockscreen_wrapper && systemctl hibernate
  else
    i3lock_wrapper && systemctl hibernate
  fi
}

if [ "$#" -eq 0 ]; then
  lock_lock
else
  while getopts "lsh" opt; do
    case $opt in
      l)
        lock_lock
        ;;
      h)
        lock_hibernate
        ;;
      \?)
        lock_lock
        ;;
    esac
  done
fi
