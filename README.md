# env

macOS environment managed by [nix-darwin](https://github.com/nix-darwin/nix-darwin) +
[home-manager](https://github.com/nix-community/home-manager) +
[nix-homebrew](https://github.com/zhaofengli/nix-homebrew).

## Fresh machine

```sh
git clone <this repo> ~/Projects/lab/env
cd ~/Projects/lab/env
./bootstrap.sh
```

This installs Determinate Nix, symlinks the repo to `~/.dotfiles`, runs the first
`darwin-rebuild switch` and installs tpm for tmux.

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

## Notes

- Karabiner rules: Left CMD -> EN, Right CMD -> RU, CapsLock -> Hyper
- Log out and back in once after the first switch - keyboard input sources
  (Russian, Polish Pro) are only picked up at login
- Not automatable, set by hand in System Settings > Keyboard:
  keyboard backlight timeout ("Never") and "Adjust keyboard brightness in
  low light" (off). Also grant Accessibility to Karabiner, Shottr and AltTab.
- `archive/` holds configs no longer in use, kept for reference (vscode)
