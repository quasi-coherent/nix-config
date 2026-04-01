{
  flake-file = {
    nixConfig = {
      extra-trusted-public-keys = [
        "quasi-coherent.cachix.org-1:3+u75bSX52FuYz64LAqVEY9+/FPztofTDfz7p9UTBEA="
      ];
      extra-substituters = [ "https://quasi-coherent.cachix.org" ];
    };
  };
}
