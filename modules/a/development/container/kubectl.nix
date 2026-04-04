{ a, ... }:
{
  our.nix-config.includes = [ a.kubectl ];

  a.kubectl.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        helm-ls
        kubectl
        kubectl-neat
        kubectl-validate
        kubectx
        stern
      ];

      programs.k9s.enable = true;

      programs.zsh.shellAliases = rec {
        kctl = "kubectl";
        kctx = "kubectx";
        kcfg = "${kctl} config";
        kns = "${kctl} get namespaces";
        kd = "k describe";
        kg = "k get";
        ked = "k edit";
        kdel = "k delete";
        kge = "k get events --sort-by'.lastTimestamp'";
        kgew = "k get events --watch'";
        kl = "k logs";
        klf = "k logs -f";
        kl1h = "k logs --since 1h";
        kl1m = "k logs --since 1m";
        kl1s = "k logs --since 1s";
        klf1h = "k logs --since 1h -f";
        klf1m = "k logs --since 1m -f";
        klf1s = "k logs --since 1s -f";
      };

      programs.zsh.siteFunctions = {
        k = ''
          args=()
          if [ -n "$KUBE_NAMESPACE" ]; then
              args=("-n" "$KUBE_NAMESPACE")
          else
              args=("--all-namespaces")
          fi
          kubectl "''${args[@]}" "$@"
        '';
      };
    };
}
