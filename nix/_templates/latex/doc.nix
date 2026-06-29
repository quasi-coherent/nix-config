{ stdenv, tex }:
stdenv.mkDerivation {
  name = "doc.pdf";
  version = "0.1.0";
  src = ./src;
  buildInputs = [ tex ];

  buildPhase = ''
    pdflatex "doc.tex"
  '';
  installPhase = ''
    mkdir -p $out/share
    mv doc.pdf $out/share
  '';
}
