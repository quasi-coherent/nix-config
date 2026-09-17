{ a, ... }:
{
  a.cloud.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        azure-cli
        aws-vault
        awscli2
        eksctl
      ];
    };

  our.nix-config.includes = [ a.cloud ];
}
