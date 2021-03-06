#!/bin/sh

## Xorg config
xset -b             # disable bell
xset s on           # enable screensaver
xset s 300 60       # dim after 5m, lock 1m after
xset +dpms          # enable DPMS
xset dpms 480 0 600 # standby after 8m, off at 10m
xset r rate 350 30  # auto-repeat delay + rate
# keyboard
numlockx & # make sure to always enable numlock anyways (calc ops)
# xinput
tpid=$(xinput list | grep -i touchpad | grep -o 'id=[0-9]*')
if [ -n "$tpid" ]; then
  tpid=${tpid#id=}
  xinput set-prop "$tpid" "libinput Tapping Enabled" 1
  xinput set-prop "$tpid" "libinput Natural Scrolling Enabled" 1
  read -r touchpad_status < "${XDG_CACHE_HOME-$HOME/.cache}/touchpad-status"
  if [ -n "$touchpad_status" ]; then
    xinput set-prop "$tpid" "Device Enabled" "$touchpad_status"
  fi; unset touchpad_status
fi; unset tpid

## User config
# import DISPLAY and PATH thus far (includes local bins and scripts)
systemctl --user import-environment DISPLAY PATH
# gnome-keyring unlock
if [ -x /usr/bin/gnome-keyring-daemon ]; then
  dbus-update-activation-environment --systemd DISPLAY
  eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets)"
  export SSH_AUTH_SOCK
fi
