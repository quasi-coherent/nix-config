{ ... }:
{
  perSystem =
    {
      crane,
      cargoArtifacts,
      manifest,
      self',
      src,
      ...
    }:
    {
      checks = {
        # Build all workspace members as part of checks.
        inherit (self'.packages) root-rs other-rs;

        cargo-clippy = crane.cargoClippy {
          inherit (manifest) pname version;
          inherit cargoArtifacts src;
          strictDeps = true;
          cargoClippyExtraArgs = "--all-features --all-targets -- -Dwarnings";
        };

        cargo-test = crane.cargoTest {
          inherit (manifest) pname version;
          inherit cargoArtifacts src;
          strictDeps = true;
          cargoTestExtraArgs = "--all-features --all-targets";
        };
      };
    };
}
