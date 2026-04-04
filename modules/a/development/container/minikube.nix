{ a, ... }:
{
  our.nix-config.includes = [ a.minikube ];

  a.minikube.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.minikube ];
    };
}
