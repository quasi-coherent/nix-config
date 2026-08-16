{
  flake.templates = {
    crate-rs = {
      description = "Single-crate rust project with fenix and crane";
      path = ./_templates/crate-rs;
    };
    crates-rs = {
      description = "Cargo workspace with fenix and crane";
      path = ./_templates/crates-rs;
    };
    latex = {
      description = "Flake app making the PDF output of src/doc.tex";
      path = ./_templates/latex;
    };
    python-shell = {
      description = "Python devshell with pyproject-nix";
      path = ./_devshells/python;
    };
    rust-shell = {
      description = "Rust devshell with fenix and crane";
      path = ./_devshells/rust;
    };
  };
}
