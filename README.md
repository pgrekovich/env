# env

macOS environment managed by [nix-darwin](https://github.com/nix-darwin/nix-darwin) +
[home-manager](https://github.com/nix-community/home-manager) +
[nix-homebrew](https://github.com/zhaofengli/nix-homebrew).

## Fresh machine

```sh
git clone https://github.com/pgrekovich/env.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

This installs Determinate Nix, runs the first `darwin-rebuild switch`, installs
tpm for tmux and the global mise tools. Cloning somewhere other than
`~/.dotfiles` also works - the scripts symlink that path for you, since
`home/home.nix` resolves its config symlinks through it.

Before bootstrap: sign into the App Store (Fantastical and Xcode install
via `mas` and need it).

After bootstrap:

- copy `config/zsh/.envs.example` to `~/.envs` and fill in the tokens
- inside tmux press `<prefix> I` to install plugins

## Everyday changes

- Nix-managed things (packages, casks, zsh, git): edit `darwin/configuration.nix`
  or `home/home.nix`, then `./rebuild.sh`
- Symlinked configs (nvim, tmux, ghostty, karabiner): edit files in `config/`
  directly, no rebuild needed

## Layout

- `flake.nix` - inputs and the single `mac` host
- `darwin/configuration.nix` - macOS defaults + homebrew casks
- `home/home.nix` - CLI packages, zsh + starship, git, config symlinks
- `config/` - live configs, symlinked into `$HOME` via mkOutOfStoreSymlink

## Manual steps macOS won't let nix do

- Log out and back in once after the first switch - keyboard input sources
  (Russian, Polish Pro) only register at login
- System Settings > Keyboard: backlight timeout ("Never") and "Adjust
  keyboard brightness in low light" (off). The old
  `com.apple.BezelServices` keys for these are dead on Apple Silicon.
- Grant Accessibility to Karabiner, Shottr and AltTab

## Notes

- Karabiner rules: Left CMD -> EN, Right CMD -> RU, CapsLock -> Hyper
- Neovim is a plain package, not `programs.neovim`: that module writes its
  own `~/.config/nvim/init.lua` and collides with the symlinked LazyVim
  config. It comes from `nixpkgs-unstable` so it tracks upstream releases
  instead of freezing with the stable channel.
- AI CLIs (codex, opencode, gemini-cli) come from brew - they release far
  too often for a stable nix channel
- node and pnpm are mise tools, not nix packages, so projects can pin their
  own versions. Global versions live in `home/home.nix`, so `mise use -g`
  won't work - edit and rebuild instead.
- `homebrew.onActivation.cleanup` is `none`. Switching it to `zap` would
  uninstall every cask not listed in `darwin/configuration.nix`.
- `archive/` holds configs no longer in use, kept for reference (vscode)
