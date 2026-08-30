((lsp-nix . ((lsp-nix-nixd-formatting-command ["fmtt"])
             (lsp-nix-nixd-nixpkgs-expr "(builtins.getFlake(\"git+file://\" + toString ./.)).inputs.nixpkgs {}")
             (lsp-nix-nixd-home-manager-options-expr "(builtins.getFlake(\"git+file://\" + toString ./.)).homeConfigurations.\"daniel@hemlock\".options"))))
