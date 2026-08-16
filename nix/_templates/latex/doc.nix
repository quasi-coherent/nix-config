{
  stdenv,
  tex,
}:
stdenv.mkDerivation {
  buildInputs = [tex];
  buildPhase = ''
    pdflatex "doc.tex"
  '';
  installPhase = ''
    mkdir -p $out/share
    mv doc.pdf $out/share
  '';
  name = "doc.pdf";
  src = ./src;
  version = "0.1.0";
}
