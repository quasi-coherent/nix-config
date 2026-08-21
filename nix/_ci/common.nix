_:
let
  actions = {
    cachix = "cachix/cachix-action@v17";
    checkout = "actions/checkout@v6";
    install-nix = "cachix/install-nix-action@v30";
    update-flake-lock = "DeterminateSystems/update-flake-lock@main";
  };
in
{
  steps = {
    cachix = {
      name = "cachix";
      uses = actions.cachix;
      with_ = {
        authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
        name = "quasi-coherent";
        signingKey = "\${{ secrets.GH_ACTIONS_SIGNING_KEY }}";
      };
    };
    checkout = {
      name = "checkout";
      uses = actions.checkout;
      with_ = {
        fetch-depth = 0;
      };
    };
    checkoutRef = ref: {
      name = "checkout-ref";
      uses = actions.checkout;
      with_ = {
        inherit ref;
        fetch-depth = 0;
      };
    };
    install = {
      name = "install";
      uses = actions.install-nix;
      with_ = {
        nix_path = "nixpkgs=channel:nixos-unstable";
      };
    };
    lockfile = {
      name = "lockfile";
      uses = actions.update-flake-lock;
      with_ = {
        git-author-email = "github-actions[bot]@users.noreply.github.com";
        git-author-name = "GitHub Action";
        gpg-passphrase = "\${{ secrets.PGP_PASSPHRASE }}";
        gpg-private-key = "\${{ secrets.PGP_PRIVATE_KEY }}";
        pr-labels = ''
          dependencies
          automated
        '';
        pr-title = "Update flake.lock";
        sign-commits = true;
      };
    };
  };
}
