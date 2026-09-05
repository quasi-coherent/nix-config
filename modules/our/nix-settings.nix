{
  lib,
  inputs,
  ...
}:
{
  our.nix-settings = {
    darwin =
      { pkgs, ... }:
      {
        launchd.daemons = {
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

        nix.settings.trusted-users = [
          "@admin"
          "@wheel"
        ];
      };

    os =
      { pkgs, ... }:
      {
        nix = {
          # We are using flakes, not channels:
          # https://github.com/NixOS/nix/issues/2982#issuecomment-2477618346
          channel.enable = false;
          gc = {
            automatic = true;
            options = "--delete-older-than 14d";
          };
          optimise.automatic = true;
          # Use the lix installer not CppNix.
          package = pkgs.lix;
          # Adding all pinned input flakes to our local registry.
          #
          # Only really important for `nix run nixpkgs#cowsay` types of invocations.
          # Without it, we fall through to the remote flake registry and completely
          # different hash of nixpkgs.
          registry = lib.mapAttrs (_name: v: { flake = v; }) inputs;
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
          };
        };
      };
  };
}
