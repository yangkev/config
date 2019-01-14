#!/usr/bin/env sh

i3lock_wrapper() {
  i3lock --ignore-empty-password --color=071715 && sleep 1
}
lock() {
  if [ -x ~/.bin/betterlockscreen ]; then
    ~/.bin/betterlockscreen --lock dimblur
  else
    i3lock_wrapper
  fi
}

suspend() {
  if [ -x ~/.bin/betterlockscreen ]; then
    ~/.bin/betterlockscreen --suspend dimblur
  else
    i3lock_wrapper && systemctl suspend
  fi
}

hibernate() {
  if [ -x ~/.bin/betterlockscreen ]; then
    ~/.bin/betterlockscreen --lock dimblur && systemctl hibernate
  else
    i3lock_wrapper && systemctl hibernate
  fi
}

while getopts "lsh" opt; do
  case $opt in
    l)
      lock
      ;;
    s)
      suspend
      ;;
    h)
      hibernate
      ;;
    \?)
      lock
      ;;
  esac
done

