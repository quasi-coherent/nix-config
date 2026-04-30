{ a, ... }:
{
  our.nix-config.includes = [ a.ssh ];

  a.ssh = {
    homeManager = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        matchBlocks."*" = {
          controlMaster = "auto";
          controlPath = "~/.ssh/socket-%r@%h:%p";
          controlPersist = "10m";
          addKeysToAgent = "yes";
        };
        matchBlocks."github.com" = {
          identityFile = "~/.ssh/id_ed25519";
          addKeysToAgent = "yes";
          extraOptions.ControlPersist = "no";
        };
        matchBlocks."gitlab.com" = {
          identityFile = "~/.ssh/gitlab_auth_ed25519";
          addKeysToAgent = "yes";
          extraOptions.ControlPersist = "no";
        };
      };

      services.ssh-agent.enable = true;
    };

    darwin.programs.ssh.knownHosts = {
      github = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
      gitlab = {
        hostNames = [ "gitlab.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      };
    };
  };
}
