#!/bin/sh
# requires:
#   dmenu (dmenu, option selection)
#   i3-msg (i3, exiting i3)
#   wmctrl (wmctrl, closing windows)
set -eu

choice=$(dmenu -i -p System <<EOF | awk '{print tolower($0)}'
Logout
Suspend
Restart
Hibernate
Shutdown
EOF
)

[ -n "$choice" ] || exit
confirm=$(printf 'no\nyes' | dmenu -p "Are you sure you want to $choice?")
[ "$confirm" = yes ] || exit

case $choice in
  logout|restart|shutdown)
    wmctrl -l | awk '{print $1}' |
      while read -r wid; do
        wmctrl -i -c "$wid"
      done

    sync # flush cached writes
esac

case $choice in
  logout)   i3-msg exit         ;;
  restart)  systemctl reboot    ;;
  shutdown) systemctl poweroff  ;;
  *)        systemctl "$choice" ;;
esac

