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

      # Hold a key to repeat it instead of showing the accent popup
      ApplePressAndHoldEnabled = false;

      # macOS rewriting what you type is never wanted while coding
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticInlinePredictionEnabled = false;

      AppleInterfaceStyleSwitchesAutomatically = true;  # follow day/night
      AppleSpacesSwitchOnActivate = true;
      AppleEnableSwipeNavigateWithScrolls = true;
    };
    dock = {
      autohide = true;
      show-recents = false;
      show-process-indicators = true;
      mru-spaces = false;      # keep Spaces in a fixed order
      expose-group-apps = false;  # Mission Control: don't group by application
      tilesize = 71;
      magnification = false;
      minimize-to-application = false;
    };
    finder = {
      FXPreferredViewStyle = "Nlsv";
      CreateDesktop = false;
      AppleShowAllFiles = true;        # hidden files visible
      ShowPathbar = true;
      ShowStatusBar = false;
      FXDefaultSearchScope = "SCcf";   # search the current folder, not the whole Mac
      ShowHardDrivesOnDesktop = false;
      ShowExternalHardDrivesOnDesktop = true;
    };

    # native screenshots go to the clipboard (Shottr handles the rest)
    screencapture.target = "clipboard";
    WindowManager.GloballyEnabled = false;  # Stage Manager off

    # settings without typed options
    CustomUserPreferences = {
      NSGlobalDomain."com.apple.sound.uiaudio.enabled" = 0;

      # Mouse tracking speed. Same key doubles as the "Pointer acceleration"
      # toggle in Mouse > Advanced: -1 turns acceleration off entirely.
      # Trackpad speed is left at the macOS default (never changed).
      NSGlobalDomain."com.apple.mouse.scaling" = 0.875;

      # US English with Polish region formats; input languages in priority order
      NSGlobalDomain.AppleLocale = "en_US@rg=plzzzz";
      NSGlobalDomain.AppleLanguages = [ "en-US" "ru-PL" "pl-PL" ];

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
      "claude"
      "chatgpt"
      "calibre"
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
      # ai cli that ships as a cask rather than a formula
      "codex"
    ];
    # No masApps on purpose. mas needs an App Store login before the switch
    # and fails the whole activation when it can't reach one, so App Store
    # apps (Xcode, Fantastical, Amphetamine) are installed by hand.
  };
}
