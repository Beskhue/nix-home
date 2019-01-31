#!/usr/bin/env bash

# Call this script as:
# $./volume-control.sh up
# $./volume-control.sh down
# $./volume-control.sh toggle-mute

step_size=5

notify() {
    # Bar code from https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a
    if [ "$1" == "mute" ]; then
        icon="audio-volume-muted"
        message=""
    else
        icon="audio-volume-high"
        message="|$(seq -s "─" $(($1 / 5)) | sed 's/[0-9]//g')|"
    fi
    
    gdbus call \
        --session \
        --dest org.freedesktop.Notifications \
        --object-path /org/freedesktop/Notifications \
        --method org.freedesktop.Notifications.Notify -- \
        "volume_control" 28593163 "${icon}" "Volume" "${message}" [] {} -1    
}

case $1 in
    up)
        # Calculate new volume.
        vol=$(amixer sget Master | grep -oP "\[\d*%\]" | head -n 1 | tr -d "[]%")
        new_vol=$((vol+step_size))

        # Ensure we're unmuted.
        amixer set Master on > /dev/null

        amixer sset Master ${new_vol}% > /dev/null

        notify ${new_vol}
        ;;
    down)
        vol=$(amixer sget Master | grep -oP "\[\d*%\]" | head -n 1 | tr -d "[]%")
        new_vol=$((vol-step_size))
        
        amixer sset Master ${new_vol}% > /dev/null

        notify ${new_vol}
        ;;
    toggle-mute)
        state=$(amixer sget Master)
        muted=$(echo -e $state | grep -oP "\[(on|off)\]" | head -n 1 | tr -d "[]")

        if [ "${muted}" == "on" ]; then
            amixer sset Master off
            notify mute
        else
            amixer sset Master on
            vol=$(echo -e $state | grep -oP "\[\d*%\]" | head -n 1 | tr -d "[]%")
            notify ${vol}
        fi
esac
