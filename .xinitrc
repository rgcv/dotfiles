#!/bin/sh
# shellcheck disable=SC1090
# based on lightdm's Xsession, logs stripped
# see https://git.archlinux.org/svntogit/packages.git/plain/trunk/Xsession?h=packages/lightdm

# Load resources
for file in /etc/X11/Xresources "$HOME/.Xresources"; do
  [ -f "$file" ] && xrdb -merge -I"${file%/*}" "$file"
done

# Load keymaps
for file in /etc/X11/Xkbmap "$HOME/.Xkbmap"; do
  [ -f "$file" ] && setxkbmap -config "$file" && XKB_IN_USE=yes
done

# Load xmodmap if not using XKB
if [ -z "$XKB_IN_USE" ]; then
  for file in /etc/X11/Xmodmap "$HOME/.Xmodmap"; do
    [ -f "$file" ] && xmodmap "$file"
  done
fi

unset file XKB_IN_USE

# Source xinitrc.d scripts
for xinitrcd in /etc/X11/xinit/xinitrc.d "$HOME/.xinitrc.d"; do
  if [ -d "$xinitrcd" ]; then
    for script in "$xinitrcd"/*; do
      [ -x "$script" ] && [ ! -d "$script" ] && . "$script"
    done
  fi
done

# Source user's .xsession
xsession=$HOME/.xsession
[ -x "$xsession" ] && [ ! -d "$xsession" ] && . "$xsession"

# run session
# optionally, first argument determines session. currently, defaults to i3
exec "${@:-i3}"
