{
  den,
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
          format = "ssh";
          key = builtins.readFile ./public_keys/signing_ed25519.pub;
          signByDefault = true;
        };
        settings = {
          user.name = "Daniel Donohue";
          user.email = "d.michael.donohue@gmail.com";
          github.user = "quasi-coherent";
          gitlab.user = "quasi-coherent";
        };
      };
      programs.ssh.matchBlocks."github.com" = {
        identityFile = "~/.ssh/id_ed25519";
	addKeysToAgent = "yes";
        extraOptions.ControlPersist = "no";
      };
    };

    darwin = {
      security.pam.services.sudo_local = {
        enable = true;
        # Use Touch ID for sudo.
        touchIdAuth = true;
        reattach = true;
      };

      users.users.daniel.openssh.authorizedKeys.keyFiles =
        lib.filesystem.listFilesRecursive ./public_keys;
    };
  };

  den.aspects.hemlock.includes = [
    our.darwin-system
    our.nix-settings
    our.theme
  ];
}
