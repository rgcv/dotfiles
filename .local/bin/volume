#!/bin/sh
# requires:
#   amixer (alsa-utils, volume management)
# uses:
#   dunstify (dunst, notifications)
#   canberra-gtk-play (libcanberra, play volume change sound
#                      libcanberra-pulse, pulseaudio backend may be required)
set -eu

# audio mixer, sink control and capabilities
mixer=default
if amixer -D pulse info >&-; then
  mixer=pulse
fi
scontrol=$(amixer -D "$mixer" scontrols |
  sed -n "s/Simple mixer control '\([^']*\)',0/\1/p" | head -n 1)
capability=$(amixer -D "$mixer" get "$scontrol" |
  sed -n "s/ Capabilities:.*cvolume.*/Capture/p")

# do some stuff
amixer -qMD "$mixer" sset "$scontrol" "$capability" "$@"
pgrep -x pactl || pkill -RTMIN+25 i3blocks

# display the notification
data=$(amixer -MD "$mixer" sget "$scontrol")
volume=$(echo "$data" | grep -o '[0-9]*%' | head -n 1)
  mute=$(echo "$data" | grep -o '\[off\]' | head -n 1)
  icon=notification-audio-volume

case $mute in
  '[off]')
    summary="Volume: Muted"
    urgency=low
    icon=$icon-muted
    ;;
  *)
    volume=${volume%\%}
    summary="Volume: $volume%"
    body=$(progress-string.sh 20 '■ ' '□ ' "$volume")

    case "$volume" in
      0) # 0 (different from muted)
        urgency=low
        icon=$icon-off
        ;;
      [1-9]|[1-3][0-9]) # 0 - 39
        urgency=low
        icon=$icon-low
        ;;
      [4-7][0-9]) # 40 - 79
        urgency=normal
        icon=$icon-medium
        ;;
      *) # >80
        urgency=critical
        icon=$icon-high
        ;;
    esac
    ;;
esac

dunstify \
  --appname "${0##*/}" \
  --urgency "$urgency" \
  --timeout 3000 \
  --icon "$icon" \
  --replace 900100 \
  "$summary" "${body-}"

canberra-gtk-play -i audio-volume-change
