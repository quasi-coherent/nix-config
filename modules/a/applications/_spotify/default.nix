{ stdenv, fetchurl, undmg }:
stdenv.mkDerivation {
  pname = "spotify";
  version = "1.2.87.414.g4e7a1155";

  src = fetchurl {
    url = "https://download.scdn.co/SpotifyARM64.dmg";
    hash = "sha256-fal0iJ/DkJXPCSUOVPj9I8Srco2GTpt4pVA8N6PD2z8=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r *.app $out/Application
    runHook postInstall
  '';
}
