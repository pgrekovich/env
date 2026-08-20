# nix-darwin base for macOS reinstall

Date: 2026-08-20

## Goal

Turn this repo into a declarative macOS setup (nix-darwin + home-manager +
nix-homebrew) so a fresh Mac reaches a working environment with one script.
Modeled after kunchenguid/dotfiles.

## Decisions

- Same repo, nix files at the root; existing `config/` stays as the home of
  live (symlinked) configs
- Prompt: starship (replaces zinit + powerlevel10k)
- Terminal: ghostty (replaces iterm/kitty); kitty config kept for reference
- Node versions: mise (replaces fnm); pnpm installed globally via nixpkgs
- Editor: neovim only; vscode configs kept in `tools/` for reference
- Casks: minimal - ghostty, karabiner-elements, raycast, google-chrome,
  brave-browser, docker-desktop; everything else installed manually (README
  keeps the reference list)
- Hyprland/waybar configs deleted - the Linux laptop runs omarchy now
- Secrets stay in `~/.envs` (outside the repo), sourced by zsh if present

## Architecture

- `flake.nix` - nixpkgs 26.05-darwin, nix-darwin 26.05, home-manager
  release-26.05, nix-homebrew; single host `mac`, user `pgrekovich`
- `darwin/configuration.nix` - macOS defaults (fast key repeat, dock autohide,
  finder tweaks), homebrew casks; `nix.enable = false` because Determinate
  manages the daemon; homebrew cleanup stays `none` until the cask list fully
  reflects the machine
- `home/home.nix` - CLI packages, zsh (aliases, history, tunnel fn), starship,
  fzf/zoxide/mise integrations, declarative git config, JetBrainsMono Nerd Font
- Live configs symlinked via mkOutOfStoreSymlink through `~/.dotfiles`:
  nvim, tmux.conf, karabiner dir, ghostty dir, gitignore_global
- `bootstrap.sh` - Determinate Nix, `~/.dotfiles` symlink, first switch, tpm
- `rebuild.sh` - everyday `darwin-rebuild switch`

## Out of scope

- Migrating tmux plugins to nix (tpm keeps managing them)
- Full cask coverage / `cleanup = "zap"`
- macOS defaults beyond the small starter set
