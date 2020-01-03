#!/bin/bash
# ensure env runs first
# shellcheck disable=SC1090
source "$HOME/.bash/env"
# prevent it from being run later, since BASH_ENV is needed
# not exported, there may be a non-login non-rc shell running as child
BASH_ENV=
source "$HOME/.bash/login"
[ -n "$PS1" ] && source "$HOME/.bash/rc"
