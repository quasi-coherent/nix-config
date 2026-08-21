{ a, ... }:
{
  a.docker.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        compose2nix
        dive
        dockerfile-language-server
        docker
        docker-compose
        lazydocker
      ];

      programs.zsh.shellAliases = {
        dils = "docker image ls";
        dipru = "docker image prune -a";
        dirm = "docker image rm";
        dirmF = "docker image rm -f";
        dlo = "docker container logs";
        dls = "docker container ls";
        dlsa = "docker container ls -a";
        dps = "docker ps";
        dpsa = "docker ps -a";
        dpu = "docker pull";
        drm = "docker container rm";
        drmF = "docker container rm -f";
        drun = "docker run --rm";
        drunit = "docker run -it --rm";
        dvls = "docker volume ls";
        dvpru = "docker volume prune";
      };
    };

  our.nix-config.includes = [ a.docker ];
}
