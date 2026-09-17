{
  # Very slick, @vic, but we're doing stuff on linux runners in CI/CD and don't
  # have any nixos hosts atm.
  # systems = lib.attrNames den.hosts;

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];
}
