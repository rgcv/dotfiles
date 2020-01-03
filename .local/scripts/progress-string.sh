#!/bin/sh
# see https://github.com/Fabian-G/dotfiles/blob/ab9ee6b/scripts/bin/getProgressString
# requires
#   bc (bc, numerical computation)
set -eu

genseq() { printf "%$1s" | sed "s| |$2|g"; }

items=${1-10}
filler=${2-+}
blankr=${3--}
value=${4-5}

 full=$(echo "(($items * $value)/100 + 0.5)/1" | bc -s)
empty=$(echo "$items - $full" | bc -s)

echo "$(genseq "$full" "$filler")$(genseq "$empty" "$blankr")"

