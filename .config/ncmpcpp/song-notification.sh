#!/bin/bash
mkdir /tmp/songart
eyeD3 --write-images=/tmp/songart $HOME/Music/$(mpc current -f %file%)
ICON=/tmp/songart/FRONT_COVER*
dunstify -a Music -u low -i $ICON "Now Playing: $(mpc current -f %title%)"
rm -rf /tmp/songart
