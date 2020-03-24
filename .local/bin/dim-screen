#!/bin/sh
# based on /usr/share/doc/xss-lock/dim-screen.sh
# requires:
#   bc (bc, rounding float -> nearest int)
#   light (light, changing screen brightness)

read -r online < /sys/class/power_supply/AC/online

min_brightness=$((5 + online*10))
fade_steps=2
fade_step_time=0.02

get_brightness() { echo "($(light)+0.5)/1" | bc -s; }
set_brightness() { light -S "$1";    }

fade_brightness() {
  if [ -n "$fade_step_time" ] && [ $fade_step_time != 0 ]; then
    start=$(get_brightness)
    [ "$start" -eq "$1" ] && return
    [ "$start" -lt "$1" ] && c=1 || c=-1
    c=$((c * fade_steps))
    start=$((start + c))
    while { [ $c -gt 0 ] && [ "$start" -lt "$1" ]; } \
       || { [ $c -lt 0 ] && [ "$start" -gt "$1" ]; }; do
      set_brightness "$start"
      sleep $fade_step_time
      start=$((start + c))
    done; unset level
  fi
  set_brightness "$1"
}

trap 'exit 0' TERM INT
# shellcheck disable=SC2064
trap "fade_brightness $(get_brightness); kill %%" EXIT
fade_brightness $min_brightness
sleep 2147483647 &
wait
