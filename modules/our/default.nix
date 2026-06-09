{
  den,
  our,
  ...
}:
{
  den.aspects.nix-config.includes = [ our.nix-config ];

  den.aspects.daniel = {
    includes = [
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")

      our.nix-config
      our.nix-config._.stable-emacs
      # our.nix-config._.latest-emacs # latest git master
      our.secrets
      our.xdg
    ];

    homeManager =
      { config, pkgs, ... }:
      let
        sops-get = pkgs.callPackage ./_pkgs/sops-get.nix { };
        cachix-push = pkgs.callPackage ./_pkgs/cachix-push.nix { inherit sops-get; };
      in
      {
        home.packages = [
          cachix-push
          sops-get
        ];

        programs.git.settings = {
          user = {
            name = "Daniel Donohue";
            email = "d.michael.donohue@gmail.com";
            signingKey = "${config.home.homeDirectory}/.ssh/signing_ed25519";
          };
          format.signoff = true;
          commit.gpgSign = true;
          tag.gpgSign = true;
          gpg.format = "ssh";
          gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
        };

        home.file = {
          ".ssh/allowed_signers" = {
            text = ''
              d.michael.donohue@gmail.com namespaces="git" ${builtins.readFile ./public_keys/signing_ed25519.pub}
            '';
            target = ".ssh/allowed_signers";
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

      users.users.daniel.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBgWmNMzpX3gRErytAME4KH+i00AYMeZ7JXJnKt21dm4"
      ];
    };
  };

  den.aspects.hemlock.includes = [
    our.darwin-system
    our.nix-settings
    our.theme
  ];
}
