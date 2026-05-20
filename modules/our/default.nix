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
      # our.nix-config._.latest-emacs # latest git master
      our.secrets
      our.xdg
    ];

    homeManager =
      { config, ... }:
      {
        programs.git.includes = [
          {
            condition = "hasconfig:remote.*.url:git@github.com:*/**";
            path = "${config.xdg.configHome}/git/githubconfig";
          }
          {
            condition = "hasconfig:remote.*.url:git@gitlab.com:*/**";
            path = "${config.xdg.configHome}/git/gitlabconfig";
          }
          {
            condition = "gitdir:~/d/git/hub/**";
            path = "${config.xdg.configHome}/git/githubconfig";
          }
        ];

        home.file = {
          ".ssh/allowed_signers" = {
            text = ''
              d.michael.donohue@gmail.com namespaces="git" ${builtins.readFile ./public_keys/signing_ed25519.pub}
              qcoh@gitlab namespaces="git" ${builtins.readFile ./public_keys/gitlab_sign_ed25519.pub}
            '';
            target = ".ssh/allowed_signers";
          };
        };

        xdg.configFile = {
          "git/githubconfig".text = ''
            [user]
                   email = "d.michael.donohue@gmail.com"
                   name = "Daniel Donohue"
                   signingKey = ${config.home.homeDirectory}/.ssh/signing_ed25519
          '';
          "git/gitlabconfig".text = ''
            [user]
                   email = "qcoh@gitlab"
                   name = "quasi-coherent"
                   signingKey = ${config.home.homeDirectory}/.ssh/gitlab_sign_ed25519
          '';
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
