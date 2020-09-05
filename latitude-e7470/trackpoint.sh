#!/bin/sh

set -e

# Print out properties
# xinput list-props 'AlpsPS/2 ALPS DualPoint Stick'

TOUCHPAD='AlpsPS/2 ALPS DualPoint TouchPad'
DUALPOINT='AlpsPS/2 ALPS DualPoint Stick'

# Disable touchpad
xinput set-prop "$TOUCHPAD" 'Device Enabled' 0

#
# libinput
#

xinput set-prop "$DUALPOINT" 'Coordinate Transformation Matrix' 0.500000, 0.000000, 0.000000, 0.000000, 0.500000, 0.000000, 0.000000, 0.000000, 1.000000

#
# evdev
#

# This sets "smooth linear" acceleration
#  https://www.x.org/wiki/Development/Documentation/PointerAcceleration/
#  https://wiki.archlinux.org/index.php/Mouse_acceleration
#xinput set-prop "$DUALPOINT" 'Device Accel Profile' 3

# Tune speed and acceleration to it
#xinput set-float-prop "$DUALPOINT" 'Device Accel Constant Deceleration' 30
#xinput set-float-prop "$DUALPOINT" 'Device Accel Velocity Scaling' 150
# Scale pixel movements "speed" down
#xinput set-float-prop "$DUALPOINT" 'Device Accel Adaptive Deceleration' 10
# "Slow" the middle button scrolling
#xinput set-prop "$DUALPOINT" 'Evdev Wheel Emulation Inertia' 100
