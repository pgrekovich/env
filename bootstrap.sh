#!/usr/bin/env bash
# Fresh Mac -> working nix-darwin setup. Run once, then use ./rebuild.sh.
#
# Deliberately not `set -e`: a step that fails must not silently swallow the
# steps after it. Every step is idempotent, so failures are collected, named at
# the end, and fixed by re-running this script.
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
FAIL_COUNT=0
FAILED_STEPS=""

# Run a named step, remember it if it fails instead of killing the script.
step() {
  local name="$1" fn="$2"
  echo "==> $name"
  if "$fn"; then
    return 0
  fi
  echo "    !! failed: $name"
  FAIL_COUNT=$((FAIL_COUNT + 1))
  FAILED_STEPS="${FAILED_STEPS}      - ${name}"$'\n'
}

determinate_nix() {
  if command -v nix >/dev/null 2>&1; then
    echo "    nix already installed, skipping"
    return 0
  fi
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm || return 1
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
}

dotfiles_symlink() {
  # home.nix resolves mkOutOfStoreSymlink paths through ~/.dotfiles. Skip the
  # symlink when the repo already lives there, or ln would nest one inside it.
  if [ "$DIR" = "$HOME/.dotfiles" ]; then
    echo "    already at ~/.dotfiles, nothing to link"
    return 0
  fi
  ln -sfn "$DIR" ~/.dotfiles
}

darwin_switch() {
  # darwin-rebuild doesn't exist yet on a fresh machine, run it from the flake.
  # sudo resets PATH, so resolve the nix binary first.
  local nix_bin
  nix_bin="$(command -v nix)" || { echo "    nix not on PATH"; return 1; }
  sudo "$nix_bin" run github:nix-darwin/nix-darwin/nix-darwin-26.05#darwin-rebuild -- \
    switch --flake ~/.dotfiles#mac
}

tpm() {
  local dir="$HOME/.config/tmux/.tmux/plugins/tpm"
  if [ -d "$dir" ]; then
    echo "    tpm already installed, skipping"
    return 0
  fi
  git clone https://github.com/tmux-plugins/tpm "$dir" || return 1
  echo "    installed. Inside tmux press <prefix> I to install plugins."
}

mise_tools() {
  # A fresh shell hasn't picked up the nix PATH yet, so fall back to the
  # profile path darwin_switch just populated.
  local mise_bin
  mise_bin="$(command -v mise || echo "/etc/profiles/per-user/${USER}/bin/mise")"
  if [ ! -x "$mise_bin" ]; then
    echo "    mise not installed yet"
    return 1
  fi
  "$mise_bin" install
}

# darwin-rebuild only reports how many Brewfile deps broke, never which ones.
# Read the Brewfile out of the activation script and name them.
missing_brew_deps() {
  local brewfile
  command -v brew >/dev/null 2>&1 || return 0
  brewfile="$(grep -o "/nix/store/[^']*-Brewfile" /run/current-system/activate 2>/dev/null | head -1)"
  [ -n "$brewfile" ] || return 0
  # check --verbose prints its findings on stderr, so fold it into stdout
  brew bundle check --verbose --file="$brewfile" 2>&1 | grep '^→' || true
}

step "Determinate Nix" determinate_nix
step "repo reachable at ~/.dotfiles" dotfiles_symlink
step "first darwin-rebuild switch" darwin_switch
step "tpm (tmux plugin manager)" tpm
step "global mise tools (node, pnpm)" mise_tools

echo
missing="$(missing_brew_deps)"
if [ "$FAIL_COUNT" -eq 0 ] && [ -z "$missing" ]; then
  echo "==> Done. Use ./rebuild.sh for future changes."
  exit 0
fi

echo "==> Finished with problems."
if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "    failed steps:"
  printf '%s' "$FAILED_STEPS"
fi
if [ -n "$missing" ]; then
  echo "    homebrew deps still missing:"
  printf '%s\n' "$missing" | sed 's/^/      /'
fi
echo "    Everything here is idempotent: fix the cause, re-run ./bootstrap.sh."
exit 1
