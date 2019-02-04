#!/usr/bin/env bash

# Call this script as:
# $./brightness-control.sh up
# $./brightness-control.sh down

step_size=10

notify() {
    # Bar code from https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a
    # icon="audio-volume-high"
    bar_size=20
    pre_bar=$(($1 * $bar_size / 100))
    post_bar=$(($bar_size - $pre_bar))
    message="$(seq -s "─" 0 $pre_bar | sed 's/[0-9]//g')|$(seq -s "─" 0 $post_bar | sed 's/[0-9]//g')"
    
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
	new_brightness=$((new_brightness < 100 ? new_brightness : 100))
        xbacklight -set ${new_brightness}%
        notify $new_brightness
        ;;
    down)
        brightness=$(floatToInt $(xbacklight -get))
        new_brightness=$((brightness-step_size))
	new_brightness=$((new_brightness < 0 ? new_brightness : 0))
        xbacklight -set ${new_brightness}%
        notify $new_brightness
        ;;
esac
