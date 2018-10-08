#!/bin/sh
set -e

tpset() { xinput set-prop "TPPS/2 IBM TrackPoint" "$@"; }
touchset() { xinput set-prop 'SynPS/2 Synaptics TouchPad' "$@"; }

tpset "Device Accel Constant Deceleration" 0.75
touchset "Device Enabled" 0
