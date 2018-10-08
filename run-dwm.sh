#!/bin/bash

. ~/environment/local/trackpoint.sh

xsetroot -solid "#303030"
xset b off

eval $(/usr/bin/killall ssh-agent; /usr/bin/ssh-agent)

# https://wiki.archlinux.org/index.php/Java#Non-reparenting_window_managers
wmname LG3D

nm-applet &
stoken-gui &

while true
do
    battery=$(upower -i $(upower -e | grep BAT) | grep --color=never -E "percentage" | awk '{print $2}')
    status="$(date +'%a %b %e %l:%M') $battery"
    xsetroot -name "$status"
    sleep 1
done &

exec /home/sbw/usr/local/bin/dwm
