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

## Installed manually (not in nix yet)

- [Bitwarden](https://bitwarden.com)
- [Spotify](https://www.spotify.com/us/download/other/)
- [Google Drive](https://www.google.com/drive/download/)
- [Transmission](https://transmissionbt.com)
- [Zoom](https://zoom.us/download)
- [Telegram](https://telegram.org)
- [Slack](https://slack.com/)
- [Shottr](https://shottr.cc)
- [Latest](https://github.com/mangerlahn/Latest)
- [AppCleaner](https://freemacsoft.net/appcleaner/)
- [IINA](https://iina.io/)
- [finicky](https://github.com/johnste/finicky)
- [Kap](https://getkap.co)
- [Keychron Engine](https://www.keychron.com/pages/how-to-install-the-keychron-engine-software-on-macos)
- [BetterDisplay Pro](https://github.com/waydabber/BetterDisplay)
- [bartender](https://www.macbartender.com)

### AppStore

- [Fantastical](https://apps.apple.com/pl/app/fantastical-calendar/id975937182?mt=12)
- [Xcode](https://apps.apple.com/pl/app/xcode/id497799835?mt=12)

## Notes

- Karabiner rules: Left CMD -> EN, Right CMD -> RU, CapsLock -> Hyper
- `tools/vscode/` is kept for reference (not in active use)
