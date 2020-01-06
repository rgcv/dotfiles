#!/bin/sh
# requires:
#   light (light, screen brightness control)
# uses:
#   bc (bc, rounding floats)
#   dunstify (dunst, notifications)
set -eu

min=5
max=100
step=5

usage() {
  cat <<EOF
Usage: ${0##*/} [-m min=$min] [-M max=$max] [-s step=$step] [+|-|[= val]]
EOF
  exit "${1-0}"
}

min() { [ "$1" -lt "$2" ] && echo "$1" || echo "$2"; }
max() { [ "$1" -gt "$2" ] && echo "$1" || echo "$2"; }
clamp() { min "$(max "$1" "$2")" "$3"; }
round() { echo "($1+0.5)/1" | bc -s; }

dispmin=$(round "$(light -P)")
while getopts "m:M:s:" opt; do
  case "$opt" in
    m) min=$(clamp "$OPTARG" "$(max "$dispmin" 1)" 100) ;;
    M) max=$(clamp "$OPTARG" "$(max "$dispmin" 1)" 100) ;;
    s) if [ "$OPTARG" -ne 0 ]; then
         step=$OPTARG
         [ "$step" -lt 0 ] && step=$((-step))
       fi
       ;;
    ?) usage 2 ;;
    *) usage 1 ;;
  esac
done
shift $((OPTIND - 1))

current=$(round "$(light)")
case "${1-}" in
  =) new=$(clamp "${2-$current}" "$min" "$max") ;;
  +) new=$(min "$((current + step))" "$max") ;;
  -) new=$(max "$((current - step))" "$min") ;;
  *) echo "$current"; exit ;;
esac
light -S "$new"

icon=notification-display-brightness
case $new in
  0) # 0
    urgency=low
    icon="$icon-off"
    ;;
  [1-9]|[1-3][0-9]) # 1 -> 39
    urgency=low
    icon="$icon-low"
    ;;
  [4-7][0-9]) # 40 -> 79
    urgency=normal
    icon="$icon-medium"
    ;;
  [8-9][0-9]|100) # 80 -> 100
    urgency=critical
    icon="$icon-full"
    ;;
esac

dunstify \
  --appname "${0##*/}" \
  --urgency "$urgency" \
  --timeout 3000 \
  --icon "$icon" \
  --replace 900101 \
  "Brightness: $new%" \
  "$(progress-string.sh 20 '■ ' '□ ' "$new")" &
