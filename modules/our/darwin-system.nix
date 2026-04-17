{ inputs, ... }:
{
  flake-file.inputs.darwin = {
    url = "github:nix-darwin/nix-darwin";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  our.darwin-system.darwin =
    { pkgs, ... }:
    {
      environment.systemPackages = with inputs.darwin.packages.${pkgs.stdenvNoCC.hostPlatform.system}; [
        darwin-option
        darwin-rebuild
        darwin-version
        darwin-uninstaller
        pkgs.age
        pkgs.cachix
        pkgs.reattach-to-user-namespace
      ];

      environment.enableAllTerminfo = true;
      environment.shellAliases.lctl = "launchctl";

      # Allows building Linux binaries.
      nix.linux-builder.enable = true;

      system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = 3.0;

      # Disable hot corners.
      system.defaults.dock = {
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
      };

      system.defaults.finder.AppleShowAllFiles = true;
      system.defaults.hitoolbox.AppleFnUsageType = "Do Nothing";
      system.defaults.LaunchServices.LSQuarantine = false;

      system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true;
      system.defaults.NSGlobalDomain."com.apple.sound.beep.volume" = 0.0;
      system.defaults.NSGlobalDomain.AppleICUForce24HourTime = true;
      system.defaults.NSGlobalDomain.AppleIconAppearanceTheme = "TintedDark";
      system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
      system.defaults.NSGlobalDomain._HIHideMenuBar = true;
      system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
      system.defaults.NSGlobalDomain.KeyRepeat = 2;

      # Infuriating.
      system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
      system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
      system.defaults.NSGlobalDomain.NSAutomaticInlinePredictionEnabled = false;
      system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
      system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
      system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
      system.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true;

      system.defaults.trackpad.Clicking = false;
      system.defaults.trackpad.TrackpadThreeFingerTapGesture = 0;

      # These have to be set together to enable the gesture.
      system.defaults.dock.autohide = true;
      system.defaults.dock.static-only = true;
      system.defaults.dock.tilesize = 32;
      system.defaults.dock.showAppExposeGestureEnabled = true;
      system.defaults.dock.showMissionControlGestureEnabled = true;
      system.defaults.trackpad.TrackpadThreeFingerHorizSwipeGesture = 2;
      system.defaults.trackpad.TrackpadThreeFingerVertSwipeGesture = 2;

      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToControl = true;

      time.timeZone = "America/New_York";
    };
}
