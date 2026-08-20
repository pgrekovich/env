#!/usr/bin/env bash
# Fresh Mac -> working nix-darwin setup. Run once, then use ./rebuild.sh.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

echo "==> Step 1: Determinate Nix"
if command -v nix >/dev/null 2>&1; then
  echo "    nix already installed, skipping"
else
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

echo "==> Step 2: symlink this repo to ~/.dotfiles"
# home.nix resolves mkOutOfStoreSymlink paths through ~/.dotfiles.
ln -sfn "$DIR" ~/.dotfiles

echo "==> Step 3: first darwin-rebuild switch"
# darwin-rebuild doesn't exist yet on a fresh machine, run it from the flake.
# sudo resets PATH, so resolve the nix binary first.
NIX_BIN="$(command -v nix)"
sudo "$NIX_BIN" run github:nix-darwin/nix-darwin/nix-darwin-26.05#darwin-rebuild -- \
  switch --flake ~/.dotfiles#mac

echo "==> Step 4: tpm (tmux plugin manager)"
TPM_DIR="$HOME/.config/tmux/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo "    installed. Inside tmux press <prefix> I to install plugins."
else
  echo "    tpm already installed, skipping"
fi

echo "==> Step 5: install global mise tools (node, pnpm)"
if command -v mise >/dev/null 2>&1; then
  mise install
else
  echo "    mise not on PATH yet, open a new shell and run: mise install"
fi

echo "==> Done. Use ./rebuild.sh for future changes."
