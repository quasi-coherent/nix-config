{ a, ... }:
{
  our.nix-config.includes = [ a.ssh ];

  a.ssh = {
    homeManager = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
          "github.com" = {
            HostName = "github.com";
            IdentityFile = "~/.ssh/id_ed25519";
            AddKeysToAgent = "yes";
          };
          "gitlab.com" = {
            HostName = "github.com";
            IdentityFile = "~/.ssh/gitlab_auth_ed25519";
            AddKeysToAgent = "yes";
          };
          "*" = {
            AddKeysToAgent = "yes";
            ControlMaster = "auto";
            ControlPath = "~/.ssh/socket-%r@%h:%p";
            ControlPersist = "10m";
          };
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
