{
  my.gitconfig.homeManager = {config, ...}: {
    home.file = {
      ".ssh/allowed_signers" = {
        target = ".ssh/allowed_signers";

        text = ''
          d.michael.donohue@gmail.com namespaces="git" ${builtins.readFile ./public_keys/signing_ed25519.pub}
        '';
      };
    };

    programs.git.settings = {
      commit.gpgSign = true;
      format.signoff = true;

      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
      };

      tag.gpgSign = true;

      user = {
        email = "d.michael.donohue@gmail.com";
        name = "Daniel Donohue";
        signingKey = "${config.home.homeDirectory}/.ssh/signing_ed25519";
      };
    };
  };
}
