#!/bin/sh
# shellcheck disable=SC2086

# notify-send.sh - drop-in replacement for notify-send with more features
# Copyright (C) 2015-2020 notify-send.sh authors (see AUTHORS file)

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Desktop Notifications Specification
# https://developer.gnome.org/notification-spec/

set -eu

SELF=${0##*/}
VERSION=1.1

URGENCY=1
EXPIRE_TIMEOUT=-1
FORCE_EXPIRE=false
APP_NAME=$SELF
APP_ICON=
PRINT_ID=false
REPLACES_ID=0
ID_FILE=

action_commands=
actions=
body=
hints=
is_positional=false
summary=
is_summary_set=false

usage() {
  err=${1-0}
  [ "$err" -eq 0 ] || exec >&2
  cat <<EOF
Usage:
  $SELF [OPTION...] <summary> [body] - create a notification

Help Options:
  -?|--help                         Show this usage message.

Application Options:
  -u, --urgency=LEVEL               Specifies the urgency level (0 low, 1
                                    normal, 2 critical).
  -t, --expire-time=TIME            Specifies the timeout in milliseconds at
                                    which to expire the notification.
  -f, --force-expire                Forcefully closes the notification when the
                                    notification has expired.
  -a, --app-name=APP_NAME           Specifies the app name for the icon.
  -i, --icon=APP_ICON[,APP_ICON...]         Specifies an icon filename or stock icon to
                                    display.
  -c, --category=TYPE[,TYPE...]     Specifies the notification category.
  -h, --hint=TYPE:NAME:VALUE        Specifies basic extra data to pass.  Valid
                                    types are boolean, int, double, string and
                                    byte.
  -o, --action=LABEL:COMMAND        Specifies an action.  Can be passed multiple
                                    times.  LABEL is usually a button's label.
                                    COMMAND is a shell command executed when
                                    action is invoked.
  -d, --default-action=COMMAND      Specifies the default action which is
                                    usually invoked by clicking the
                                    notification.
  -l, --close-action=COMMAND        Specifies the action invoked when
                                    notification is closed.
  -p, --print-id                    Print the notification ID to the standard
                                    output.
  -r, --replace=ID                  Replace existing notification.
  -R, --replace-file=FILE           Store and load notification replace ID
                                    to/from this file.
  -s, --close=ID                    Close notification.
  -v, --version                     Version of the package.
EOF
  exit "$err"
}

check_missing() { [ -n "${2-}" ] || die "Missing argument for $1"; }

die() { echo >&2 "$SELF: $*"; exit 1; }

gdbus_call() {
  gdbus call \
    --session \
    --dest org.freedesktop.Notifications \
    --object-path /org/freedesktop/Notifications \
    "$@"
}

format_action() { echo "\"${1%:*}\", \"${1#*:}\""; }

format_hint() {
  hint=$1
  typ=${hint%%:*}; hint=${hint#*:}
  echo "\"${hint%%:*}\": <$typ ${hint#*:}>"
}

join() {
  map=$1; shift

  c=0
  res=
  for el in "$@"; do
    [ $c -gt 0 ] && res="$res, "
    res="$res$($map "$el")"
    c=$((c + 1))
  done

  echo "$res"
}

maybe_run_action_handler() {
  if [ -n "$1" ] && [ -n "$action_commands" ]; then
    notify_action=${0%/*}/notify-action.sh
    [ -x "$notify_action" ] || die "executable file not found: $notify_action"
    $notify_action "$1" $action_commands &
    exit
  fi
}

handle_urgency() {
  case $1 in
    low)      URGENCY=0  ;;
    normal)   URGENCY=1  ;;
    critical) URGENCY=2  ;;
    *) die "Unknown urgency $1 specified. Known urgency levels: low, normal, critical" ;;
  esac
}

handle_expire_time() {
  expr "$1" : "-\?[0-9]\+$" >/dev/null || die "invalid expire time: $1"
  EXPIRE_TIMEOUT=$1
}

handle_category() {
  cs=$1

  c=
  res=
  while [ "$c" != "$cs" ]; do
    c=${cs%%,*}
    cs=${cs#*,}
    # shellcheck disable=SC2089
    res="$res string:category:\"$c\""
  done
  [ -n "$res" ] || res="$res string:category:\"$cs\""
  hints="$hints $res"
}

handle_hint() {
  hint=$1

  colons=$(echo "$hint" | tr -dc :)
  [ ${#colons} -gt 1 ] || die "Invalid hint syntax specified. Use TYPE:NAME:VALUE."

  typ=${hint%%:*}
  case $typ in
    int) typ=int32 ;;
    int32|boolean|double|string|byte) ;;
    *) die "Invalid hint type \"$typ\". Valid types are boolean, int, double, string, byte." ;;
  esac

  hint=${hint#*:}
  name=${hint%%:*}
  val=${hint#*:}

  if [ "$typ" = string ]; then
    val=${val#\"}
    # shellcheck disable=SC2089
    val="\"${val%\"}\""
  fi
  hints="$hints $typ:$name:$val"
}

make_action_key() {
  key=$(echo "$1" | tr -dc _A-Z-a-z-0-9)
  rnd=$(printf "%s" "$(od -A n -N 4 -t u /dev/urandom)")
  echo "$key${rnd#*[0-9]}"
}

handle_action() {
  name=${1%:*}
  cmd=${1#*:}

  if [ -z "$name" ] || [ -z "$cmd" ]; then
    die "Invalid action syntax specified. Use NAME:COMMAND."
  fi

  key=$(make_action_key "$name")
  action_commands="$action_commands $key $cmd"
  actions="$actions $key:$name"
}

handle_named_action() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    die "Command must not be empty"
  fi

  action_commands="$action_commands $2 $2"
  [ "$1" = close ] || actions="$actions $1:$2"
}

handle_replace_file() {
  [ -s "$1" ] && read -r REPLACES_ID < "$1"
  ID_FILE=$1
}

handle_close () {
  id=$1
  # always check that --close provides a numeric value
  if [ -z "$id" ] || ! expr "$id" : "[0-9]\+$" >/dev/null; then
    die "Invalid close id: $id"
  fi
  if [ "$EXPIRE_TIMEOUT" -gt 0 ]; then
    s=${EXPIRE_TIMEOUT%[0-9]}; s=${s%[0-9]}; s=${s%[0-9]}
    ms=${EXPIRE_TIMEOUT#$s}
    sleep "$s.$ms"
  fi
  gdbus_call \
    --method org.freedesktop.Notifications.CloseNotification \
    "$1" >/dev/null
}

handle_arg() {
  case $1 in
    -*) $is_positional || die "Unknown option $1" ;;
     *) ;;
  esac
  $is_summary_set && body=$1 || summary=$1 is_summary_set=true;
}

# shellcheck disable=SC2090
notify() {
  actions=$(join format_action $actions)
  hints=$(join   format_hint   $hints  )

  nid=$(gdbus_call \
    --method org.freedesktop.Notifications.Notify \
    "$APP_NAME" \
    "$REPLACES_ID" \
    "$APP_ICON" \
    "$summary" \
    "$body" \
    "[$actions]" \
    "{$hints}" \
    "int32 $EXPIRE_TIMEOUT")
  nid=${nid#* }
  nid=${nid%,)}

  [ -z "$ID_FILE" ] || echo "$nid" > "$ID_FILE"
  $PRINT_ID && echo "$nid"

  $FORCE_EXPIRE && handle_close "$nid"

  maybe_run_action_handler "$nid"
}

while [ $# -gt 0 ]; do
  case $1 in
    -\?|--help) usage ;;

    -v|--version) echo "$SELF $VERSION"; exit ;;

    -u|--urgency)
      check_missing $1 "${2-}"
      handle_urgency "$2"
      shift
      ;;
    --urgency=*) handle_urgency "${1#*=}" ;;

    -t|--expire-time)
      check_missing $1 "${2-}"
      handle_expire_time "$2"
      shift
      ;;
    --expire-time=*) handle_expire_time "${1#*=}" ;;

    -f|--force-expire) FORCE_EXPIRE=true ;;

    -a|--app-name)
      check_missing $1 "${2-}"
      APP_NAME=$2
      shift
      ;;
     --app-name=*) APP_NAME=${1#*=} ;;

    -i|--icon)
      check_missing $1 "${2-}"
      APP_ICON=$2
      shift
      ;;
     --icon=*) APP_ICON=${1#*=} ;;

    -c|--category)
      check_missing $1 "${2-}"
      handle_category "$2"
      shift
      ;;
     --category=*) handle_category "${1#*=}" ;;

    -h|--hint)
      check_missing $1 "${2-}"
      handle_hint "${2-}"
      shift
      ;;
     --hint=*) handle_hint "${1#*=}" ;;

    -o|--action)
      check_missing $1 "${2-}"
      handle_action "$2"
      shift
      ;;
     --action=*) handle_action "${1#*=}" ;;

    -d|--default-action)
      check_missing $1 "${2-}"
      handle_named_action default "$2"
      shift
      ;;
     --default-action=*) handle_named_action default "${1#*=}" ;;

    -l|--close-action)
      check_missing $1 "${2-}"
      handle_named_action close "$2"
      shift
      ;;
     --close-action=*) handle_named_action close "${1#*=}" ;;

    -p|--print-id) PRINT_ID=true ;;

    -r|--replace)
      check_missing $1 "${2-}"
      REPLACES_ID=$2
      shift
      ;;
     --replace=*) REPLACES_ID=${1#*=} ;;

    -R|--replace-file)
      check_missing $1 "${2-}"
      handle_replace_file "$2"
      shift
      ;;
     --replace-file=*) handle_replace_file "${1#*=}" ;;

    -s|--close)
      check_missing $1 "${2-}"
      handle_close "${2-}"
      exit $?
      ;;
     --close=*) handle_close "${1#*=}"; exit $? ;;

    --) is_positional=true ;;

     *) handle_arg "$1" ;;
  esac
  shift
done

# always force --replace and --replace-file to provide a numeric value; 0 means no id provided
if [ -z "$REPLACES_ID" ] || ! expr "$REPLACES_ID" : "[0-9]\+$" >/dev/null; then
  REPLACES_ID=0
fi

# urgency is always set
hints="byte:urgency:$URGENCY $hints"

$is_summary_set || usage 1

notify
