# Icons

`neovide.svg` is the source; `neovide.icns` is built from it.

The outline is a superellipse sampled at 720 points, not a rounded rect and
definitely not a circle: 824x824 centred in a 1024 canvas with 100px margins,
which is Apple's own icon grid, so it sits at the same size as every other
icon in the Dock.

```sh
nix run nixpkgs#resvg -- neovide.svg icon.png -w 1024 -h 1024
mkdir icon.iconset
for s in "16 16x16" "32 16x16@2x" "32 32x32" "64 32x32@2x" "128 128x128" \
         "256 128x128@2x" "256 256x256" "512 256x256@2x" "512 512x512" "1024 512x512@2x"; do
  sips -z ${s% *} ${s% *} icon.png --out "icon.iconset/icon_${s#* }.png"
done
iconutil -c icns icon.iconset -o neovide.icns
```

Applying it is *not* automated. macOS App Management (13+) refuses writes into
another app's bundle, which is where both routes lead: `Contents/Resources`
holds the icns, and a custom icon lands as `Icon\r` at the bundle root.
Overwriting the icns would also void Neovide's notarisation. Either grant the
terminal App Management in Privacy & Security, or set it by hand through
Finder's Get Info. A cask upgrade replaces the app and reverts it either way.
