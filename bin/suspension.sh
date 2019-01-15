#!/usr/bin/env sh
LOCKER="$HOME/config/bin/lock.sh"

BAT_SCREENSAVER_TIME="300"
BAT_DPMS_SUSPEND_TIME="310"
BAT_DPMS_OFF_TIME="600"
BAT_SUSPEND_TIME="10"

POW_SCREENSAVER_TIME="600"
POW_DPMS_SUSPEND_TIME="610"
POW_DPMS_OFF_TIME="900"
POW_SUSPEND_TIME="30"

keep_displays_on() {
  # disable screen saver (and implicitly, autolocking via xss-lock) and disable display power management
  xset s off -dpms

  # disable auto-suspend timer
  xautolock -exit
}

set_timeout() {
  xset s off
  # Lock after 5 min (300s) via xss-lock
  # display -> suspend 10sec later (310s)
  # display -> off after 10 min (600s)
  xset s "$SCREENSAVER_TIME" dpms 0 "$DPMS_SUSPEND_TIME" "$DPMS_OFF_TIME"

  # make sure xss-lock is on, so lock happens for suspend, screensaver events
  xss-lock -l -- "$LOCKER" >/dev/null 2>&1 &

  # suspend system after 10 minutes
  xautolock -exit >/dev/null 2>&1 && sleep 1
  xautolock -time "$SUSPEND_TIME" -detectsleep -locker 'systemctl suspend' >/dev/null 2>&1 &
}

set_battery() {
  SCREENSAVER_TIME="$BAT_SCREENSAVER_TIME"
  DPMS_SUSPEND_TIME="$BAT_DPMS_SUSPEND_TIME"
  DPMS_OFF_TIME="$BAT_DPMS_OFF_TIME"
  SUSPEND_TIME="$BAT_SUSPEND_TIME"

  set_timeout
}

set_plugged_in() {
  SCREENSAVER_TIME="$POW_SCREENSAVER_TIME"
  DPMS_SUSPEND_TIME="$POW_DPMS_SUSPEND_TIME"
  DPMS_OFF_TIME="$POW_DPMS_OFF_TIME"
  SUSPEND_TIME="$POW_SUSPEND_TIME"

  set_timeout
}

configure_power_settings() {
  bat=$(acpi -a)
  if [ "$bat" = "Adapter 0: on-line" ]; then
    set_plugged_in
  else
    set_battery
  fi
}


if [ "$#" -eq 0 ]; then
  configure_power_settings
  exit 0
fi

while getopts "o" opt; do
  case $opt in
    o)
      keep_displays_on
      ;;
    *)
      configure_power_settings
      ;;
  esac
done
