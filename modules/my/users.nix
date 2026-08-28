{
  den,
  my,
  our,
  ...
}:
{
  den.aspects = {
    daniel = {
      includes = [
        den.batteries.primary-user
        (den.batteries.user-shell "zsh")

        my.gitconfig
        my.shortcuts

        our.home
        our.nix-config
        our.nix-config._.stable-emacs
        # our.nix-config._.latest-emacs # latest git master
        our.secrets
        our.theme
      ];

      provides.to-hosts = _: {
        darwin.users.users.daniel.openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBgWmNMzpX3gRErytAME4KH+i00AYMeZ7JXJnKt21dm4"
        ];
      };
    };
  };
}
