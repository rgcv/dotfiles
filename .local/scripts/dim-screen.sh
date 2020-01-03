#!/bin/sh
# based on /usr/share/doc/xss-lock/dim-screen.sh

## CONFIGURATION ##############################################################

# Brightness will be lowered to this value.
min_brightness=2

# If you have a driver without RandR backlight property (e.g. radeon), set this
# to use the sysfs interface and create a .conf file in /etc/tmpfiles.d/
# containing the following line to make the sysfs file writable for group
# "users":
#
#     m /sys/class/backlight/acpi_video0/brightness 0664 root users - -
#
#sysfs_path=/sys/class/backlight/acpi_video0/brightness
sysfs_path=

# Time to sleep (in seconds) between increments when using sysfs. If unset or
# empty, fading is disabled.
fade_step_time=0.02

###############################################################################

get_brightness() {
  if [ -z $sysfs_path ]; then
    light -r
  else
    cat $sysfs_path
  fi
}

set_brightness() {
  if [ -z $sysfs_path ]; then
    light -rS "$1"
  else
    echo "$1" > $sysfs_path
  fi
}

fade_brightness() {
  if [ -z $fade_step_time ]; then
    set_brightness "$1"
  else
    start=$(get_brightness)
    [ "$start" -eq "$1" ] && return
    [ "$start" -lt "$1" ] && c=1 || c=-1
    while [ "$start" -ne "$1" ]; do
      start=$((start + c))
      set_brightness "$start"
      sleep $fade_step_time
    done; unset level
  fi
}

trap 'exit 0' TERM INT
# shellcheck disable=SC2064
trap "fade_brightness $(get_brightness); kill %%" EXIT
fade_brightness $min_brightness
sleep 2147483647 &
wait
