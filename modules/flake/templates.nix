{
  flake = {
    templates.crate-rs = {
      path = ./templates/crate-rs;
      description = "Rust project flake with fenix and crane";
    };
  };
}
