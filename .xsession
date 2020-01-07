#!/bin/sh

## Xorg config
xset -b            `# disable bell` \
     s on          `# enable screensaver` \
     s 180 60      `# dim after 3m, lock 1m after` \
     +dpms         `# enable DPMS` \
     dpms 300      `# standby after 5m` \
     r rate 350 30 `# auto-repeat delay + rate`
# keyboard
numlockx & # make sure to always enable numlock anyways (calc ops)
setxkbmap \
  -option 'caps:escape' `# bind caps to escape` \
  -option 'numpad:mac'  `# numpad is always numeric`
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
  eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
  export SSH_AUTH_SOCK
fi
