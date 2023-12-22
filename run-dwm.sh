#!/bin/bash

. ~/environment/local/trackpoint.sh

time_format="%I:%M %p"

xsetroot -solid "#303030"
xset b off

eval $(/usr/bin/killall ssh-agent; /usr/bin/ssh-agent)

# https://wiki.archlinux.org/index.php/Java#Non-reparenting_window_managers
wmname LG3D

nm-applet &
blueman-applet &
lxpolkit &

xrdb -merge ~/environment/home/.Xdefaults

while true
do
    battery=$(upower -i $(upower -e | grep BAT) | grep --color=never -E "percentage" | awk '{print $2}')
    pacific_time=$(TZ=America/Los_Angeles date +"$time_format %m/%d")
    eastern_time=$(TZ=America/New_York date +"$time_format")
    art_time=$(TZ=America/Argentina/Buenos_Aires date +"$time_format")
    paris_time=$(TZ=Europe/Paris date +"$time_format")
    status="$pacific_time | $eastern_time | $art_time | $paris_time | $battery"
    #status="$(date +'%a %b %e %l:%M') $battery"
    xsetroot -name "$status"
    sleep 1
done &

exec /home/sbw/usr/local/bin/dwm
