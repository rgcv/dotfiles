#!/bin/sh
# based on lightdm's Xsession
# see https://git.archlinux.org/svntogit/packages.git/plain/trunk/Xsession?h=packages/lightdm

# Load resources
for file in /etc/X11/Xresources "$HOME/.Xresources"; do
  if [ -f "$file" ]; then
    echo "Merging resource: $file"
    xrdb -merge -I"${file%/*}" "$file"
  fi
done

# Load keymaps
for file in /etc/X11/Xkbmap "$HOME/.Xkbmap"; do
  if [ -f "$file" ]; then
    echo "Loading keymap: $file"
    # shellcheck disable=SC2046
    setxkbmap $(cat "$file")
    XKB_IN_USE=yes
  fi
done

# Load xmodmap if not using XKB
if [ -z "$XKB_IN_USE" ]; then
  for file in /etc/X11/Xmodmap "$HOME/.Xmodmap"; do
    if [ -f "$file" ]; then
      echo "Loading xmodmap: $file"
      xmodmap "$file"
    fi
  done
fi

unset XKB_IN_USE

# Source xinitrc.d scripts
for xinitrcd in /etc/X11/xinit/xinitrc.d "$HOME/.xinitrc.d"; do
  if [ -d "$xinitrcd" ]; then
    for script in "$xinitrcd"/*; do
      # shellcheck disable=SC1090
      if [ -x "$script" ] && [ ! -d "$script" ]; then
        echo "Sourcing script: $script"
        . "$script"
      fi
    done
  fi
done

# Source user's .xsession
xsession=$HOME/.xsession
if [ -x "$xsession" ] && [ ! -d "$xsession" ]; then
  echo "Sourcing xsession: $xsession"
  # shellcheck disable=SC1090
  . "$xsession"
fi

# run session
# optionally, first argument determines session. currently, defaults to i3
case "${1-default}" in
  default)
    echo "Running default session"
    exec i3
    ;;
  *)
    echo "Running '$*'"
    exec "$@"
    ;;
esac
