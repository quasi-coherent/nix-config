{ bash, stdenv }:
stdenv.mkDerivation {
  name = "sketchybar-bin";
  src = ./bin;
  nativeBuildInputs = [ bash ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ${./bin}/*.sh $out/bin/
    cp ${./bin}/items/*.sh $out/bin/
    cp ${./bin}/plugins/*.sh $out/bin/
    cp ${./bin}/plugins/net/*.sh $out/bin/
    chmod +x $out/bin/*.sh
  '';
}
