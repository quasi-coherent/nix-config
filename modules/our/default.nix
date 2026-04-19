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

    homeManager =
      let
        signingKey = builtins.readFile ./public_keys/signing_ed25519.pub;
      in
      {
        programs.git = {
          settings = {
            user = {
              inherit signingKey;
              name = "Daniel Donohue";
              email = "d.michael.donohue@gmail.com";
            };
            commit.gpgsign = true;
            gpg.format = "ssh";
            gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
            github.user = "quasi-coherent";
            gitlab.user = "quasi-coherent";
          };
        };
        programs.ssh.matchBlocks."github.com" = {
          identityFile = "~/.ssh/id_ed25519";
          addKeysToAgent = "yes";
          extraOptions.ControlPersist = "no";
        };
        home.file."allowed_signers" = {
          target = ".ssh/allowed_signers";
          text = signingKey;
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
