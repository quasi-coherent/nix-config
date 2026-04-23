{
  flake.templates = {
    crate-rs = {
      path = ./templates/crate-rs;
      description = "Rust project flake with fenix and crane";
    };

    latex = {
      path = ./templates/latex;
      description = "LaTeX template--nix run for PDF output of src/doc.tex";
    };
  };
}
