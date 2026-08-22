_: {
  our.darwin-system.darwin =
    {
      pkgs,
      inputs',
      ...
    }:
    {
      # https://mastodon.online/@nomeata/109915786344697931
      documentation.enable = false;
      environment = {
        # 2026-05-23: Changed to `false` because enableAllTerminfo brings in
        # `termite.terminfo`, which requires VTE to build, which fails on MacOS
        # Tahoe 26.x.
        enableAllTerminfo = false;
        shellAliases.lctl = "launchctl";

        systemPackages = [
          inputs'.darwin.packages.darwin-option
          inputs'.darwin.packages.darwin-rebuild
          inputs'.darwin.packages.darwin-version
          inputs'.darwin.packages.darwin-uninstaller

          pkgs.age
          pkgs.cachix
          pkgs.reattach-to-user-namespace

          # Add back terminfo that we needed from `enableAllTerminfo = true`.
          # We have to do this here because `programs.alacritty.enable` etc. adds
          # terminfo in the wrong place.
          pkgs.alacritty.terminfo
          pkgs.tmux.terminfo
        ];

        variables = {
          LANG = "en_US.UTF-8";
          LC_ALL = "en_US.UTF-8";
        };
      };
      nix = {
        # Allows building Linux binaries.
        linux-builder = {
          config.virtualisation = {
            cores = 6;

            darwin-builder = {
              diskSize = 40 * 1024;
              memorySize = 8 * 1024;
            };
          };

          enable = true;
          ephemeral = true;
          maxJobs = 4;
        };

        # Required for the linux-builder.
        settings.trusted-users = [ "@admin" ];
      };
      security.pam.services.sudo_local = {
        enable = true;
        # Allow auth to survive between session boundaries.
        reattach = true;
        # Use Touch ID for sudo.
        touchIdAuth = true;
      };
      system = {
        defaults = {
          ".GlobalPreferences"."com.apple.mouse.scaling" = 3.0;
          LaunchServices.LSQuarantine = false;

          NSGlobalDomain = {
            AppleICUForce24HourTime = true;
            AppleIconAppearanceTheme = "TintedDark";
            AppleInterfaceStyle = "Dark";
            InitialKeyRepeat = 15;
            KeyRepeat = 2;
            # Infuriating.
            NSAutomaticCapitalizationEnabled = false;
            NSAutomaticDashSubstitutionEnabled = false;
            NSAutomaticInlinePredictionEnabled = false;
            NSAutomaticPeriodSubstitutionEnabled = false;
            NSAutomaticQuoteSubstitutionEnabled = false;
            NSAutomaticSpellingCorrectionEnabled = false;
            NSWindowShouldDragOnGesture = true;
            "com.apple.keyboard.fnState" = true;
            "com.apple.sound.beep.volume" = 0.1;
          };

          # Disable hot corners.
          dock = {
            wvous-bl-corner = 1;
            wvous-br-corner = 1;
            wvous-tl-corner = 1;
            wvous-tr-corner = 1;
          };

          dock.autohide = true;
          # These have to be set together to enable the gesture.
          dock.showAppExposeGestureEnabled = true;
          dock.showMissionControlGestureEnabled = true;
          dock.static-only = true;
          dock.tilesize = 32;

          finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            FXPreferredViewStyle = "clmv";
            NewWindowTarget = "Computer";
            _FXShowPosixPathInTitle = true;
          };

          hitoolbox.AppleFnUsageType = "Do Nothing";

          trackpad = {
            Clicking = false;
            TrackpadThreeFingerHorizSwipeGesture = 2;
            TrackpadThreeFingerTapGesture = 0;
            TrackpadThreeFingerVertSwipeGesture = 2;
          };
        };

        keyboard = {
          enableKeyMapping = true;
          remapCapsLockToControl = true;
        };
      };
      system.stateVersion = 6;
      time.timeZone = "America/New_York";
    };
}
