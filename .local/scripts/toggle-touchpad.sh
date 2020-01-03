#!/bin/sh
# requires:
#   xinput (xorg-xinput, property setting)
# uses:
#   canberra-gtk-play (libcanberra, sound)
#   dunstify (dunst, notifications)
set -eu

file=${XDG_CACHE_HOME-$HOME/.cache}/touchpad-status
setting="Device Enabled"

tpid=$(xinput list | grep -i touchpad | grep -o 'id=[0-9]*')
tpid=${tpid#id=}
[ -n "$tpid" ] || exit

if [ -f "$file" ]; then
  read -r status < "$file"
else
  mkdir -p "${file%/*}"
  status=$(xinput list-props "$tpid" | awk -F: '$0 ~ /'"$setting"'/ {print $2}')
fi

new=$((status^1))
if [ $new -eq 0 ]; then
  urgency=low
  icon=notification-touchpad-disabled-symbolic
  summary="Touchpad Disabled"
else
  urgency=normal
  icon=notification-input-touchpad-symbolic
  summary="Touchpad Enabled"
fi

if xinput set-prop "$tpid" "$setting" $new && echo $new > "$file"; then
  dunstify \
    --appname "${0##*/}" \
    --urgency "$urgency" \
    --timeout 3000 \
    --icon "$icon" \
    --replace 900102 \
    "$summary" &
fi
