#!/usr/bin/env sh

kill_ext_displays() {
  for output in $(xrandr -q | grep "connected" | grep -v "primary" | cut -d ' ' -f1)
  do
    xrandr --output $output --off
  done 
}

extend_displays() {
  # get display line and the highest resolution output line in 1
  ext_lines=$(xrandr -q | grep -v "primary" | grep -P "\sconnected" -A 1)
  ext_disp=$(echo "$ext_lines" | cut -d ' ' -f1)
  ext_res=$(echo "$ext_lines" | tail -n 1 | sed -r 's/^\s*//' | cut -d ' ' -f1)
  ext_x=$(echo "$ext_res" | cut -d 'x' -f1)
  ext_y=$(echo "$ext_res" | cut -d 'x' -f2)

  pri_lines=$(xrandr -q | grep "primary" -A 1) 
  pri_disp=$(echo "$pri_lines" | cut -d ' ' -f1)
  pri_res=$(echo "$pri_lines" | tail -n 1 | sed -r 's/^\s*//' | cut -d ' ' -f1)
  pri_x=$(echo "$pri_res" | cut -d 'x' -f1)
  pri_y=$(echo "$pri_res" | cut -d 'x' -f2)

  x_scale=$(echo "scale=3; ${pri_x}/${ext_x}" | bc) 
  y_scale=$(echo "scale=3; ${pri_y}/${ext_y}" | bc)

  xrandr --output "$ext_disp" --auto --scale "$x_scale"x"$y_scale" --right-of "$pri_disp"
}

duplicate_displays() {
  # get display line and the highest resolution output line in 1
  ext_lines=$(xrandr -q | grep -v "primary" | grep -P "\sconnected" -A 1)
  ext_disp=$(echo "$ext_lines" | cut -d ' ' -f1)
  ext_res=$(echo "$ext_lines" | tail -n 1 | sed -r 's/^\s*//' | cut -d ' ' -f1)
  ext_x=$(echo "$ext_res" | cut -d 'x' -f1)
  ext_y=$(echo "$ext_res" | cut -d 'x' -f2)

  pri_lines=$(xrandr -q | grep "primary" -A 1) 
  pri_disp=$(echo "$pri_lines" | cut -d ' ' -f1)
  pri_res=$(echo "$pri_lines" | tail -n 1 | sed -r 's/^\s*//' | cut -d ' ' -f1)
  pri_x=$(echo "$pri_res" | cut -d 'x' -f1)
  pri_y=$(echo "$pri_res" | cut -d 'x' -f2)

  x_scale=$(echo "scale=3; ${pri_x}/${ext_x}" | bc) 
  y_scale=$(echo "scale=3; ${pri_y}/${ext_y}" | bc)

  xrandr --output "$ext_disp" --auto --scale "$x_scale"x"$y_scale" --same-as "$pri_disp"
}
while getopts ":edx" opt; do
  case $opt in
    e)
      extend_displays
      ;;
    d)
      duplicate_displays
      ;;
    x)
      kill_ext_displays
      ;;
    \?)
      echo "invalid argument"
      exit 1
  esac
done
