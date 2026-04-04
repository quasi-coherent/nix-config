{ a, ... }:
{
  our.nix-config.includes = [ a.docker ];

  a.docker.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        dockerfile-language-server
        docker
        docker-compose
        lazydocker
      ];

      programs.zsh.shellAliases = {
        dls = "docker container ls";
        dlsa = "docker container ls -a";
        dlo = "docker container logs";
        drm = "docker container rm";
        drmF = "docker container rm -f";
        dils = "docker image ls";
        dirm = "docker image rm";
        dirmF = "docker image rm -f";
        dipru = "docker image prune -a";
        dps = "docker ps";
        dpsa = "docker ps -a";
        dpu = "docker pull";
        drun = "docker run --rm";
        drunit = "docker run -it --rm";
        dvls = "docker volume ls";
        dvpru = "docker volume prune";
      };
    };
}
