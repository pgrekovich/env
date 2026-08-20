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

  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    finder.FXPreferredViewStyle = "Nlsv";
    finder.CreateDesktop = false;
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
    ];
    # requires being signed into the App Store before the switch
    masApps = {
      "Fantastical" = 975937182;
      "Xcode" = 497799835;
    };
  };
}
