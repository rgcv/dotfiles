#!/bin/sh
git clone --bare https://github.com/rgcv/.dotfiles.git "$HOME/.dotfiles"
function dots() {
  git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"
}
dots checkout -f
dots config status.showUntrackedFiles no
