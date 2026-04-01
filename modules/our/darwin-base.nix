{ inputs, ... }:
{
  flake-file.inputs.darwin.url = "github:nix-darwin/nix-darwin";

  our.darwin-base = {
    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = with inputs.darwin.packages.${pkgs.stdenvNoCC.hostPlatform.system}; [
          darwin-option
          darwin-rebuild
          darwin-version
          darwin-uninstaller
        ];

        system.keyboard.enableKeyMapping = true;
        system.keyboard.remapCapsLockToControl = true;

        system.defaults = {
          CustomUserPreferences."com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };

          dock.autohide = true;
          dock.show-recents = false;
          dock.static-only = true;
          dock.tilesize = 32;
          dock = {
            # nix-darwin.github.io/nix-darwin/manual/index.html#opt-system.defaults.dock.wvous-bl-corner
            wvous-bl-corner = 1; # disable
            wvous-br-corner = 4; # Desktop
            wvous-tl-corner = 1;
            wvous-tr-corner = 1;
          };

          finder.AppleShowAllFiles = true;
          finder.AppleShowAllExtensions = true;
          finder.FXDefaultSearchScope = "SCcf"; # Current folder
          finder.PreferredViewStyle = "Nlsv"; # Show a list

          LaunchServices.LSQuarantine = false;

          menuExtraClock.show24Hour = true;
          menuExtraClock.showDate = true;
          menuExtraClock.ShowSeconds = true;

          NSGlobalDomain."com.apple.sound.beep.volume" = 0.0;
          NSGlobalDomain.AppleICUForce24HourTime = true;
          NSGlobalDomain.AppleIconAppearanceTheme = "Dark";
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
          NSGlobalDomain.ApplePressAndHoldEnabled = false;
          NSGlobalDomain.InitialKeyRepeat = 15;
          NSGlobalDomain.KeyRepeat = 2;
          NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
          NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
          NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
          NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
          NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
          NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;

          trackpad.Clicking = true;
          trackpad.ThreeFingerDrag = true;
          trackpad.TrackpadThreeFingerVertSwipeGesture = 2;
        };
      };
  };
}
