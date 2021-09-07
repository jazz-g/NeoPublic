#!/bin/bash
ICON=$HOME/.config/awesome/icons/system/lock.png
TMPBG=/tmp/$RANDOM.png
sleep 0.5
scrot $TMPBG
convert $TMPBG -filter Gaussian -blur 0x8 $TMPBG
convert $TMPBG $ICON -gravity center -composite -matte $TMPBG
i3lock -u --image=$TMPBG
rm $TMPBG
