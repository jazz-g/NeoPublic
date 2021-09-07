#!/bin/bash
#
# Rofi powered menu to change awesome tiling
if [ $2 = "PBTN" ] || [ $2 = "PWRF" ]; then

# major jank right here
su -c '	
export DISPLAY=:0.0
export XAUTHORITY=/home/"YOUR_USERNAME"/.Xauthority


shutdown=""
reboot=""
hibernate=""
sus=""
lock=""
logoff=""

chosen=$(printf "%s;%s;%s;%s;%s;%s\n" "$shutdown" "$reboot" "$hibernate" "$sus" "$lock" "$logoff" \
	| rofi -theme "menus/shutdown.rasi" \
           -dmenu \
	   -sep ";" \
           -selected-row 1)

case "$chosen" in
    "$shutdown")	systemctl poweroff ;;
    "$reboot")		systemctl reboot ;;
    "$hibernate")	$HOME/.config/awesome/scripts/lock_screen.sh && systemctl hibernate ;;
    "$sus")   		$HOME/.config/awesome/scripts/lock_screen.sh && systemctl suspend ;;
    "$lock")  		$HOME/.config/awesome/scripts/lock_screen.sh ;;
    "$logoff")	 	awesome-client "awesome.quit()" ;;
    *)          exit 1 ;;
esac

# The variable can be used as a command"s options, so it shouldn"t be quoted.
# shellcheck disable=2086
' neo
fi
