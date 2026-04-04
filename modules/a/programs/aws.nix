{ a, ... }:
{
  our.nix-config.includes = [ a.aws ];

  a.aws.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        aws-vault
        awscli2
        eksctl
      ];
    };
}
