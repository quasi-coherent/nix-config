{a, ...}: {
  a.ssh = {
    homeManager = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        settings = {
          "*" = {
            AddKeysToAgent = "yes";
            ControlMaster = "auto";
            ControlPath = "~/.ssh/socket-%r@%h:%p";
            ControlPersist = "10m";
          };

          "github.com" = {
            AddKeysToAgent = "yes";
            HostName = "github.com";
            IdentityFile = "~/.ssh/id_ed25519";
          };

          "gitlab.com" = {
            AddKeysToAgent = "yes";
            HostName = "gitlab.com";
            IdentityFile = "~/.ssh/id_ed25519";
          };
        };
      };

      services.ssh-agent.enable = true;
    };

    darwin.programs.ssh.knownHosts = {
      github = {
        hostNames = ["github.com"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };

      gitlab = {
        hostNames = ["gitlab.com"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      };
    };
  };

  our.nix-config.includes = [a.ssh];
}
