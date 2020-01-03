#!/bin/sh
# requires:
#   any window compositor (picom, compton, xcompmgr, ...)
#   transset-df (transset-df, setting transparency)
set -eu

window=$(xdotool getactivewindow)
delay=0.2
opacity=0.75
times=2

usage() {
  cat <<USAGE
Usage: ${0##*/} [-d <delay=$delay>] [-o <opacity=$opacity]
    [-t <times=$times>]
USAGE
  exit "${1-0}"
}

while getopts "d:o:t:" opt; do
  case $opt in
    d) delay=$OPTARG   ;;
    o) opacity=$OPTARG ;;
    t) times=$OPTARG   ;;
    ?) usage 1 ;;
  esac
done; shift $((OPTIND - 1))

for _ in $(seq 1 "$times"); do
  sleep "$delay"
  transset-df -i "$window" "$opacity"
  sleep "$delay"
  transset-df -i "$window" 1
done

