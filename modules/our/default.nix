{
  den,
  inputs,
  lib,
  our,
  ...
}:
{
  den.aspects.nix-config.includes = [ our.nix-config ];

  den.aspects.daniel = {
    includes = [
      den._.primary-user
      (den._.user-shell "zsh")

      our.nix-config
      our.secrets
      our.xdg
    ];

    homeManager = {
      programs.git = {
        signing = {

        };
        settings = {
          user.name = "Daniel Donohue";
          user.email = "d.michael.donohue@gmail.com";
          user.signingkey = "CEA9C9F18658A642";

          github.user = "quasi-coherent";
          gitlab.user = "quasi-coherent";
        };
      };
    };

    darwin = {
      security.pam.services.sudo_local = {
        enable = true;
        # Use Touch ID for sudo.
        touchIdAuth = true;
        reattach = true;
      };
      users.users.daniel.openssh.authorizedKeys.keys = lib.pipe inputs.import-tree [
        (i: i.initFilter (lib.hasSuffix ".pub"))
        (i: i.map builtins.readFile)
        (i: i.withLib lib)
        (i: i.leafs ./public_keys)
      ];
    };
  };

  den.aspects.hemlock.includes = [
    our.darwin-system
    our.nix-settings
    our.theme
  ];
}
