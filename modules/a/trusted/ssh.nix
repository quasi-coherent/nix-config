{ a, ... }:
{
  our.nix-config.includes = [ a.ssh ];

  a.ssh.homeManager = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks."*" = {
        controlMaster = "auto";
        controlPath = "~/.ssh/socket-%r@%h:%p";
        controlPersist = "10m";
        addKeysToAgent = "yes";
      };
    };

    services.ssh-agent.enable = true;
  };
}
