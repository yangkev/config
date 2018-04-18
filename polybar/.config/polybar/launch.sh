#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch bars on all outputs
for output in $(xrandr -q | grep " connected" | cut -d ' ' -f1)
do
    export MONITOR=$output
    polybar top &
done
