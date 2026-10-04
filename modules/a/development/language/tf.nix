{ a, den, ... }:
{
  a.tf = {
    includes = [
      (den.batteries.unfree [ "terraform" ])
    ];
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          terraform
          terraform-ls
          terraform-landscape
        ];
      };
  };

  our.nix-config.includes = [ a.tf ];
}
