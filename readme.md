# nix-config

[`nix-darwin`][nd] and [`home-manager`][hm] with [`den`][den].

## flake

Maybe useful outputs:

* `nix-config.denful.a`: The den [namespace][dns] [`a`](./modules/a/).
* `nix-config.packages.latestEmacsForMyNeeds`: emacs master branch and the set of
  [packages](./modules/a/development/_emacs/pkgsFor.nix) I use.
* `nix-config.packages.stableEmacsForMyNeeds`: emacs unstable release and the set
  of packages I use.
* `nix-config.templates`: Some templates I find useful that are at least close to
  working without modification.

[nd]: https://github.com/nix-darwin/nix-darwin
[hm]: https://github.com/nix-community/home-manager
[den]: https://github.com/denful/den
[dns]: https://den.denful.dev/guides/namespaces/
