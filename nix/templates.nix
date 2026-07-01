{
  flake.templates = {
    crate-rs = {
      path = ./_templates/crate-rs;
      description = "Single-crate rust project with fenix and crane";
    };

    crates-rs = {
      path = ./_templates/crates-rs;
      description = "Cargo workspace with fenix and crane";
    };

    latex = {
      path = ./_templates/latex;
      description = "Flake app making the PDF output of src/doc.tex";
    };

    rust-shell = {
      path = ./_devshells/rust;
      description = "Rust devshell with fenix and crane";
    };

    python-shell = {
      path = ./_devshells/python;
      description = "Python devshell with pyproject-nix";
    };
  };
}
