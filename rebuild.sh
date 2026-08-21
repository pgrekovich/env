#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# Skip when the repo already lives there, or ln would nest one inside it.
[ "$DIR" = "$HOME/.dotfiles" ] || ln -sfn "$DIR" ~/.dotfiles
# A shell opened before the first switch has no nix PATH yet, and sudo resets
# PATH regardless, so resolve the binary instead of trusting the lookup.
DARWIN_REBUILD="$(command -v darwin-rebuild || echo /run/current-system/sw/bin/darwin-rebuild)"
exec sudo "$DARWIN_REBUILD" switch --flake ~/.dotfiles#mac
