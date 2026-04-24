{
  flake.templates = {
    crate-rs = {
      path = ./_templates/crate-rs;
      description = "Single-crate rust project with fenix and crane";
    };

    latex = {
      path = ./_templates/latex;
      description = "Flake app making the PDF output of src/doc.tex";
    };

    rust-shell = {
      path = ./_devshells/rust-stable;
      description = "Rust devshell with stable toolchain from fenix";
    };
  };
}
