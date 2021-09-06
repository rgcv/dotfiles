#!/bin/bash
# ensure env runs first
# shellcheck disable=SC1091
source "${XDG_CONFIG_HOME-$HOME/.config}/bash/env"
# prevent it from being run later, since BASH_ENV is needed
# not exported, there may be a non-login non-rc shell running as child
BASH_ENV=
source "${XDG_CONFIG_HOME-$HOME/.config}/bash/login"
[ -n "$PS1" ] && source "${XDG_CONFIG_HOME-$HOME/.config}/bash/rc"
