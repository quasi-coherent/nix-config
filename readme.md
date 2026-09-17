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

#### TODOs

- Fix the templates and make them better.
- `den` lets you make diagrams of stuff, so do that.  Put it in a folder.  Spend
time trying to do it from GitHub actions; fail entirely.  Come out at the end of
the exercise having not improved at all.
- A WSL2 configuration modernized to belong here.
- Useful Lima VMs I maybe use.
- Why does the theme go back to boring when I quit Spotify? Tell me that.
- KKP

[nd]: https://github.com/nix-darwin/nix-darwin
[hm]: https://github.com/nix-community/home-manager
[den]: https://github.com/denful/den
[dns]: https://den.denful.dev/guides/namespaces/
[dgm]: https://den.denful.dev/explanation/diagrams/
