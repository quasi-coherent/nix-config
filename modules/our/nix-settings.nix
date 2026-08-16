{lib, ...}: {
  our.nix-settings = {
    # This avoids evaluating nixpkgs all the time.
    homeManager.nix.registry = lib.mapAttrs (_name: v: {flake = v;}) {};

    darwin = {pkgs, ...}: {
      launchd = {
        daemons = {
          # Clean up old gcroots and broken symlinks weekly.
          nix-cleanup-gcroots = {
            script = ''
              set -eu
              # delete auto gcroots older than > 30 days
              ${pkgs.findutils}/bin/find /nix/var/nix/gcroots/auto /nix/var/nix/gcroots/per-user -type l -mtime +30 -delete || true
              # made by nix-collect-garbage, could be stale
              ${pkgs.findutils}/bin/find /nix/var/nix/temproots -type f -mtime +10 -delete || true
              # delete broken symlinks
              ${pkgs.findutils}/bin/find /nix/var/nix/gcroots -xtype l -delete || true
            '';

            serviceConfig = {
              StartCalendarInterval = [
                {
                  Hour = 3;
                  Minute = 30;
                  Weekday = 0; # Sunday
                }
              ];
            };
          };

          nix-daemon = {
            serviceConfig.Nice = -10;
          };
        };
      };
    };

    os = {pkgs, ...}: {
      nix = {
        gc = {
          automatic = true;
          options = "--delete-older-than 14d";
        };

        optimise.automatic = true;
        # Use the lix installer not CppNix.
        package = pkgs.lix;

        settings = {
          extra-experimental-features = [
            "nix-command"
            "flakes"
          ];

          keep-derivations = true;
          # for nix-direnv
          keep-outputs = true;

          substituters = [
            "https://quasi-coherent.cachix.org"
            "https://nix-community.cachix.org"
          ];

          trusted-public-keys = [
            "quasi-coherent.cachix.org-1:3+u75bSX52FuYz64LAqVEY9+/FPztofTDfz7p9UTBEA="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];

          trusted-users = ["@wheel"];
        };
      };
    };
  };
}
