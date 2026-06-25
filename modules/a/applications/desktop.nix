{ a, den, ... }:
{
  our.nix-config.includes = [ a.desktop ];

  a.desktop = {
    includes = [
      (den.batteries.unfree [
        "slack"
        "zoom-us"
      ])
    ];

    homeManager =
      { lib, pkgs, ... }:
      let
        # All of the places I'm aware of where zoom leaves garbage after you uninstall it.
        zoom-bullshit = pkgs.writeShellScriptBin "fd-zoomware" ''
          ${pkgs.fd}/bin/fd '(us\.)?[z|Z]oom' -E '*Accessibility*' -E '*CommandLineTools*' --prune -td ~/Library
          ${pkgs.fd}/bin/fd '(us\.)?[z|Z]oom' -E '*Accessibility*' -E '*CommandLineTools*' --prune -td /Library
          ${pkgs.fd}/bin/fd '(us\.)?[z|Z]oom' -E '*Accessibility*' -tf ~/Library
          ${pkgs.fd}/bin/fd '(us\.)?[z|Z]oom' -E '*Accessibility*' -tf /Library
        '';
      in
      {
        home.packages =
          with pkgs;
          [
            slack
            slack-cli
            # zoom-us
          ]
          ++ lib.optional pkgs.stdenv.isDarwin zoom-bullshit;
      };
  };
}
