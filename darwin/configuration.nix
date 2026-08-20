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

    # no typed option for this one
    CustomUserPreferences.NSGlobalDomain."com.apple.sound.uiaudio.enabled" = 0;
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
