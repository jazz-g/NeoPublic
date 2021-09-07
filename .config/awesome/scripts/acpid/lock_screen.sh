#!/bin/bash

if [ $3 = "close" ]; then

# major jank right here
su -c '
export DISPLAY=:0.0
export XAUTHORITY=/home/"YOUR_USERNAME"/.Xauthority
ICON=$HOME/.config/awesome/icons/system/lock.png
TMPBG=/tmp/$RANDOM.png
scrot $TMPBG
convert $TMPBG -filter Gaussian -blur 0x8 $TMPBG
convert $TMPBG $ICON -gravity center -composite -matte $TMPBG
i3lock -u --image=$TMPBG
rm $TMPBG
' neo
systemctl suspend
fi
