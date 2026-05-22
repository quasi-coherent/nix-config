{ ... }:
{
  flake-file.inputs.darwin = {
    url = "github:nix-darwin/nix-darwin";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  our.darwin-system.darwin =
    { inputs', pkgs, ... }:
    let
      ndPkgs = inputs'.darwin.packages;
      hmPkgs = inputs'.home-manager.packages;
    in
    {
      # 2026-05-23: Changed to `false` because enableAllTerminfo brings in
      # `termite.terminfo`, which requires VTE to build, which fails on MacOS
      # Tahoe 26.x.
      environment.enableAllTerminfo = false;
      environment.shellAliases.lctl = "launchctl";
      environment.variables = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
      };

      environment.systemPackages = [
        hmPkgs.home-manager

        ndPkgs.darwin-option
        ndPkgs.darwin-rebuild
        ndPkgs.darwin-version
        ndPkgs.darwin-uninstaller

        pkgs.age
        pkgs.cachix
        pkgs.reattach-to-user-namespace

        # Add back terminfo that we needed from `enableAllTerminfo = true`.
        # We have to do this here because `programs.alacritty.enable` etc. adds
        # terminfo in the wrong place.
        pkgs.alacritty.terminfo
        pkgs.tmux.terminfo
      ];

      # Allows building Linux binaries.
      nix.linux-builder = {
        enable = true;
        ephemeral = true;
        maxJobs = 4;
        config.virtualisation = {
          cores = 6;
          darwin-builder.diskSize = 40 * 1024;
          darwin-builder.memorySize = 8 * 1024;
        };
      };
      # Required for the linux-builder.
      nix.settings.trusted-users = [ "@admin" ];

      system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = 3.0;

      # Disable hot corners.
      system.defaults.dock = {
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
      };

      system.defaults.finder.AppleShowAllFiles = true;
      system.defaults.finder.AppleShowAllExtensions = true;
      system.defaults.finder.FXPreferredViewStyle = "clmv";
      system.defaults.finder.NewWindowTarget = "Computer";
      system.defaults.finder._FXShowPosixPathInTitle = true;

      system.defaults.hitoolbox.AppleFnUsageType = "Do Nothing";
      system.defaults.LaunchServices.LSQuarantine = false;

      system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true;
      system.defaults.NSGlobalDomain."com.apple.sound.beep.volume" = 0.0;
      system.defaults.NSGlobalDomain.AppleICUForce24HourTime = true;
      system.defaults.NSGlobalDomain.AppleIconAppearanceTheme = "TintedDark";
      system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
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
