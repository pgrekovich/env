# nix-darwin base for macOS reinstall

Date: 2026-08-20

## Goal

Turn this repo into a declarative macOS setup (nix-darwin + home-manager +
nix-homebrew) so a fresh Mac reaches a working environment with one script.
Modeled after kunchenguid/dotfiles.

## Decisions

- Same repo, nix files at the root; existing `config/` stays as the home of
  live (symlinked) configs
- Prompt: starship (replaces zinit + powerlevel10k); fzf-tab kept as the one
  hand-added zsh plugin
- Terminal: ghostty (replaces iterm/kitty)
- Node/pnpm versions: mise (replaces fnm), both declared as mise global tools
  rather than nixpkgs packages, so projects can override them
- Editor: neovim from `nixpkgs-unstable` as a plain package. The
  `programs.neovim` module writes its own `~/.config/nvim/init.lua` and
  collides with the symlinked LazyVim config
- Casks cover the whole desktop (~29), so a fresh machine needs no manual
  installs; App Store apps go through `masApps`
- AI CLIs (codex, opencode, gemini-cli) come from brew, not nixpkgs - they
  release far too often for a stable channel
- Hyprland/waybar configs deleted - the Linux laptop runs omarchy now
- Secrets stay in `~/.envs` (outside the repo), sourced by zsh if present

## Architecture

- `flake.nix` - nixpkgs 26.05-darwin, nix-darwin 26.05, home-manager
  release-26.05, nix-homebrew, plus a `nixpkgs-unstable` input used only for
  neovim; single host `mac`, user `ph`
- `darwin/configuration.nix` - macOS defaults (keyboard, dock, Mission Control,
  Stage Manager, sounds, input sources), homebrew brews/casks/masApps;
  `nix.enable = false` because Determinate manages the daemon; homebrew
  cleanup stays `none` until the cask list fully reflects the machine
- `home/home.nix` - CLI packages, zsh (aliases, history, fzf-tab), starship,
  fzf/zoxide/mise integrations, declarative git config via
  `programs.git.settings`, JetBrainsMono Nerd Font
- Live configs symlinked via mkOutOfStoreSymlink through `~/.dotfiles`:
  nvim, tmux.conf, karabiner dir, ghostty dir, gitignore_global
- `bootstrap.sh` - Determinate Nix, `~/.dotfiles` symlink, first switch, tpm,
  mise install
- `rebuild.sh` - everyday `darwin-rebuild switch`

## Verified

`nix build .#darwinConfigurations.mac.system` completes on the pre-reinstall
machine. Activation (`darwin-rebuild switch`) was deliberately not run there:
the config targets user `ph`, and nix-homebrew would take over the existing
Homebrew install.

## Not automatable, left manual

- Keyboard backlight timeout and low-light adjustment: the old
  `com.apple.BezelServices` keys are dead on Apple Silicon
- Accessibility permissions for Karabiner, Shottr, AltTab
- Log out once after the first switch so input sources register

## Out of scope

- Migrating tmux plugins to nix (tpm keeps managing them)
- `cleanup = "zap"` for homebrew
