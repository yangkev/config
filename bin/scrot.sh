#!/bin/bash

feh_command='feh --draw-actions --fullscreen $f'
# Press "a" to bring up actions, then 0 to save screenshot to ~/Pictures/screenshots/
feh_action='--action '\''[save to ~/Pictures/screenshots/] cp -t ~/Pictures/screenshots/ %f'\'''
# cleanup temporary image file
rm_command='rm $f'

scrot --select --exec \
  "$feh_command $feh_action; $rm_command"
