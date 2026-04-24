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

      our.cache
      our.nix-config
      our.nix-config._.stable-emacs
      # our.nix_config._.latest-emacs # latest git master
      our.secrets
      our.xdg
    ];

    homeManager =
      { config, ... }:
      {
        programs.git = {
          settings = {
            github.user = "quasi-coherent";
            gitlab.user = "quasi-coherent";
            user.name = "Daniel Donohue";
            user.email = "d.michael.donohue@gmail.com";

            gpg.format = "ssh";
            user.signingKey = "${config.home.homeDirectory}/.ssh/signing_ed25519";
            gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";

            commit.gpgSign = true;
            tag.gpgSign = true;
            format.signoff = true;
          };
        };

        home.file.".ssh/allowed_signers" = {
          text = ''d.michael.donohue@gmail.com namespaces="git" ${builtins.readFile ./public_keys/signing_ed25519.pub}'';
          target = ".ssh/allowed_signers";
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
