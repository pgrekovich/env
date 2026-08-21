{ user, lib, ... }:

let
  # macOS system shortcuts live in com.apple.symbolichotkeys under numeric ids
  # (undocumented by Apple, but stable). Each one listed here gets switched
  # off; the comment is what the id means in System Settings > Keyboard.
  disabledHotkeys = {
    "64" = "Show Spotlight search (cmd+space) - belongs to Raycast";

    # Layout switching is already handled twice over, by the Karabiner
    # Left CMD -> en / Right CMD -> ru rules and by AppleFnUsageType below.
    # ctrl+space on top of that only collides with IDE completion and tmux.
    "60" = "Select the previous input source (ctrl+space)";
    "61" = "Select the next input source (ctrl+opt+space)";

    # ctrl+arrows move between Spaces, which fights Hyper Navigation and
    # pane movement in tmux/nvim.
    "79" = "Move left a space (ctrl+left)";
    "80" = "Move right a space (ctrl+right)";
    "81" = "Move up a space (ctrl+up)";
    "82" = "Move down a space (ctrl+down)";

    # fn is claimed by AppleFnUsageType = 1 for input sources, so the
    # Emoji & Symbols binding on the same key has to go.
    "164" = "Show Emoji & Symbols (globe/fn)";
  };

  # One `-dict-add` per id, deliberately not a single `defaults write` of the
  # whole AppleSymbolicHotKeys dict: that replaces the value outright, so every
  # id macOS already stores there and this file doesn't mention would be lost.
  # Activation runs as root (postUserActivation is gone in 26.05), so drop into
  # the user's context the way nix-darwin writes its own user defaults.
  # Applied at login, like the other keyboard settings here.
  disableHotkey = id: what: ''
    # ${what}
    launchctl asuser "$(id -u -- ${user})" sudo --user=${user} -- \
      defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
        -dict-add ${id} '<dict><key>enabled</key><false/></dict>'
  '';
in

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

      # The badge that pops up next to the cursor on every layout switch.
      # With fn and both CMD keys all switching layouts, it is constant noise.
      # kCFPreferencesAnyApplication is the same domain as NSGlobalDomain.
      NSGlobalDomain.TSMLanguageIndicatorEnabled = 0;

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

  system.activationScripts.postActivation.text =
    lib.concatStrings (lib.mapAttrsToList disableHotkey disabledHotkeys);

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
