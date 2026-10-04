{
  my.gitconfig.homeManager =
    { config, ... }:
    {
      home.file = {
        ".ssh/allowed_signers" = {
          target = ".ssh/allowed_signers";

          text = ''
            d.michael.donohue@gmail.com namespaces="git" ${builtins.readFile ./public_keys/signing_ed25519.pub}
          '';
        };
      };

      programs =
        let
          allowedSigners = "${config.home.homeDirectory}/.ssh/allowed_signers";
          email = "d.michael.donohue@gmail.com";
          name = "Daniel Donohue";
          signingKey = "${config.home.homeDirectory}/.ssh/signing_ed25519";
        in
        {
          git.settings = {
            commit.gpgSign = true;
            format.signoff = true;
            gpg = {
              format = "ssh";
              ssh.allowedSignersFile = allowedSigners;
            };
            tag.gpgSign = true;
            user = { inherit name email signingKey; };
          };

          jujutsu.settings = {
            signing = {
              backend = "ssh";
              backends.ssh.allowed-signers = allowedSigners;
              behavior = "own";
              key = signingKey;
            };
            user = { inherit name email; };
          };
        };
    };
}
