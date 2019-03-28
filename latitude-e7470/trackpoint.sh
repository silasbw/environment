#!/bin/sh

set -e

# Disable touchpad
xinput set-prop 'AlpsPS/2 ALPS DualPoint TouchPad' 'Device Enabled' 0

# This sets "smooth linear" acceleration
#  https://www.x.org/wiki/Development/Documentation/PointerAcceleration/
#  https://wiki.archlinux.org/index.php/Mouse_acceleration
xinput set-prop 'AlpsPS/2 ALPS DualPoint Stick' 'Device Accel Profile' 3

# Tune speed and acceleration to it
xinput set-float-prop 'AlpsPS/2 ALPS DualPoint Stick' 'Device Accel Constant Deceleration' 30
xinput set-float-prop 'AlpsPS/2 ALPS DualPoint Stick' 'Device Accel Velocity Scaling' 150
# Scale pixel movements "speed" down
xinput set-float-prop 'AlpsPS/2 ALPS DualPoint Stick' 'Device Accel Adaptive Deceleration' 10
# "Slow" the middle button scrolling
xinput set-prop 'AlpsPS/2 ALPS DualPoint Stick' 'Evdev Wheel Emulation Inertia' 100

# Print out properties
# xinput list-props 'AlpsPS/2 ALPS DualPoint Stick'
