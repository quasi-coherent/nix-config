_: {
  perSystem =
    {
      cargoArtifacts,
      crane,
      crateName,
      self',
      src,
      ...
    }:
    let
      inherit (crateName { }) pname version;
    in
    {
      checks = {
        # Build all workspace members as part of checks.
        inherit (self'.packages) facade-rs other-rs;

        cargo-clippy = crane.cargoClippy {
          inherit
            pname
            version
            cargoArtifacts
            src
            ;
          cargoClippyExtraArgs = "--all-features --all-targets -- -Dwarnings";
          strictDeps = true;
        };

        cargo-test = crane.cargoTest {
          inherit
            pname
            version
            cargoArtifacts
            src
            ;
          cargoTestExtraArgs = "--all-features --all-targets";
          strictDeps = true;
        };
      };
    };
}
