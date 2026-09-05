{ a, ... }:
{
  a.k8s.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        helm-ls
        # It is conspicuously missing, but don't try to install kubectl here.
        # It's provided by minikube and it will cause errors because of
        # conflicting subpaths.  I'd rather just not install it here than
        # override the minikube derivation to not install it over there, even
        # though it would be better to manage kubectl separately.
        #
        # kubectl
        kubectl-neat
        kubectl-validate
        kubectx
        minikube
        stern
      ];

      programs = {
        k9s.enable = true;

        zsh = {
          shellAliases = rec {
            kcfg = "${kctl} config";
            kctl = "kubectl";
            kctx = "kubectx";
            kd = "k describe";
            kdel = "k delete";
            ked = "k edit";
            kg = "k get";
            kge = "k get events --sort-by'.lastTimestamp'";
            kgew = "k get events --watch'";
            kl = "k logs";
            kl1h = "k logs --since 1h";
            kl1m = "k logs --since 1m";
            kl1s = "k logs --since 1s";
            klf = "k logs -f";
            klf1h = "k logs --since 1h -f";
            klf1m = "k logs --since 1m -f";
            klf1s = "k logs --since 1s -f";
            kns = "${kctl} get namespaces";
          };

          siteFunctions = {
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
      };
    };

  our.nix-config.includes = [ a.k8s ];
}
