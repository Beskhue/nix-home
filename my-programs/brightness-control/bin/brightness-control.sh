#!/usr/bin/env bash

# Call this script as:
# $./brightness-control.sh up
# $./brightness-control.sh down

step_size=10

notify() {
    # Bar code from https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a
    # icon="audio-volume-high"
    message="|$(seq -s "─" $(($1 / 5)) | sed 's/[0-9]//g')|"
    
    gdbus call \
        --session \
        --dest org.freedesktop.Notifications \
        --object-path /org/freedesktop/Notifications \
        --method org.freedesktop.Notifications.Notify -- \
        "brightness_control" 28593163 "${icon}" "Brightness" "${message}" [] "{\"urgency\": <byte 0>}" -1
}

floatToInt() {
    printf "%.0f\n" "$1"
}

case $1 in
    up)
        brightness=$(floatToInt $(xbacklight -get))
        new_brightness=$((brightness+step_size))
        xbacklight -set ${new_brightness}%
        notify $new_brightness
        ;;
    down)
        brightness=$(floatToInt $(xbacklight -get))
        new_brightness=$((brightness-step_size))
        xbacklight -set ${new_brightness}%
        notify $new_brightness
        ;;
esac
