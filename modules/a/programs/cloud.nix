{a, ...}: {
  a.aws.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      aws-vault
      awscli2
      eksctl
    ];
  };

  our.nix-config.includes = [a.aws];
}
