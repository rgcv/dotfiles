#!/bin/sh
set -eu

query() { setxkbmap -query | awk '/^'"$1"':/ {print $2}'; }

layout=$(query layout)
variant=$(query variant)

[ -r "$HOME/.Xkbmap" ] && setxkbmap -config "$HOME/.Xkbmap"

case "${1-}" in
  pt|us|'us(intl)') setxkbmap "$1" ;;
  *)
    if [ "$layout" = pt ]; then
      setxkbmap us
    elif [ "$layout" = us ]; then
      if [ -z "$variant" ]; then
        setxkbmap us intl
      else
        setxkbmap pt
      fi
    fi
    ;;
esac

if [ -n "${2-}" ]; then
  setxkbmap -variant "$2"
fi

pkill -RTMIN+20 i3blocks
