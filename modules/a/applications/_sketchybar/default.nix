{ bash, stdenv }:
stdenv.mkDerivation {
  name = "sketchybar-bin";
  src = ./bin;
  nativeBuildInputs = [ bash ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src/*.sh $out/bin/
    cp $src/plugins/*.sh $out/bin/
    cp $src/plugins/net/*.sh $out/bin/
    chmod +x $out/bin/*.sh
  '';
}
