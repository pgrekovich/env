#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# Skip when the repo already lives there, or ln would nest one inside it.
[ "$DIR" = "$HOME/.dotfiles" ] || ln -sfn "$DIR" ~/.dotfiles
exec sudo darwin-rebuild switch --flake ~/.dotfiles#mac
