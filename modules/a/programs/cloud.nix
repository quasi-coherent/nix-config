{ a, ... }:
{
  a.cloud.homeManager =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        let
          az = azure-cli.withExtensions [
            azure-cli-extensions.init
          ];
        in
        [
          az
          aws-vault
          awscli2
          eksctl
        ];
    };

  our.nix-config.includes = [ a.cloud ];
}
