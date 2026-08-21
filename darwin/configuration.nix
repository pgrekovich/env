{ user, ... }:

{
  # Determinate Nix manages the daemon itself, nix-darwin must not touch it.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;

  system.startup.chime = false;

  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      AppleShowAllExtensions = true;
      "com.apple.sound.beep.feedback" = 0;  # no sound on volume change
      "com.apple.swipescrolldirection" = true;  # natural scrolling
    };
    dock = {
      autohide = true;
      show-recents = false;
      show-process-indicators = true;
      mru-spaces = false;      # keep Spaces in a fixed order
      expose-group-apps = false;  # Mission Control: don't group by application
    };
    finder.FXPreferredViewStyle = "Nlsv";
    finder.CreateDesktop = false;
    WindowManager.GloballyEnabled = false;  # Stage Manager off

    # settings without typed options
    CustomUserPreferences = {
      NSGlobalDomain."com.apple.sound.uiaudio.enabled" = 0;

      # Mouse tracking speed. Same key doubles as the "Pointer acceleration"
      # toggle in Mouse > Advanced: -1 turns acceleration off entirely.
      # Trackpad speed is left at the macOS default (never changed).
      NSGlobalDomain."com.apple.mouse.scaling" = 0.875;

      # Keyboard layouts and the fn key. Applied at login, so the input
      # sources only show up after logging out and back in.
      "com.apple.HIToolbox" = {
        AppleFnUsageType = 1;  # fn switches input source
        AppleEnabledInputSources = [
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 0;
            "KeyboardLayout Name" = "U.S.";
          }
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 19456;
            "KeyboardLayout Name" = "Russian";
          }
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 30788;
            "KeyboardLayout Name" = "Polish Pro";
          }
          {
            "Bundle ID" = "com.apple.CharacterPaletteIM";
            InputSourceKind = "Non Keyboard Input Method";
          }
          {
            "Bundle ID" = "com.apple.PressAndHold";
            InputSourceKind = "Non Keyboard Input Method";
          }
        ];
      };
    };
  };

  nix-homebrew = {
    enable = true;
    inherit user;
  };

  homebrew = {
    enable = true;
    # "zap" would uninstall every cask not listed here - switch to it once
    # this list fully reflects the machine.
    onActivation.cleanup = "none";
    onActivation.autoUpdate = true;
    # ai clis move too fast for nixpkgs stable, brew keeps them fresh
    brews = [
      "codex"
      "opencode"
      "gemini-cli"
    ];
    casks = [
      # password managers first - nothing else is reachable without them
      "1password"
      "bitwarden"
      "ghostty"
      "karabiner-elements"
      "raycast"
      "google-chrome"
      "brave-browser"
      "docker-desktop"
      "spotify"
      "telegram"
      "slack"
      "shottr"
      "finicky"
      "todoist-app"
      "fastmail"
      "obsidian"
      "discord"
      "the-unarchiver"
      "tailscale-app"
      "claude-code"
      "alt-tab"
      "localsend"
      "qlmarkdown"
      "google-drive"
      "transmission"
      "zoom"
      "iina"
      "kap"
      "appcleaner"
      "latest"
      "betterdisplay"
      # menu bar manager: open source, replaces bartender
      "jordanbaird-ice"
    ];
    # requires being signed into the App Store before the switch
    masApps = {
      "Fantastical" = 975937182;
      "Xcode" = 497799835;
      "Amphetamine" = 937984704;
    };
  };
}
