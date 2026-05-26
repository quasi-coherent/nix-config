{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10_29_2,
  nodejs,
  electron,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "legcord";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "Legcord";
    repo = "Legcord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nai8lcimEts/E3bwUyQufLYIHhUK83IH431PUQFtQJI=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_10_29_2
    nodejs
    makeWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10_29_2;
    fetcherVersion = 3;
    hash = "sha256-ME74yxVwH4W9gE0XbtwDhR8g9QulN2eeOB1eekaHmG8=";
  };

  env = {
    CSC_IDENTITY_AUTO_DISCOVERY = "false";
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    # "File descriptor closed but not opened in unmanaged mode" will show up
    # 65,000 times without turning off warnings.  Something about pnpm doing a
    # thing that node got the the start of but not the end of because of course
    # it's that way.  This is JS tooling.
    NODE_NO_WARNINGS = 1;
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    # electron-builder fails because it lists a directory that has contents only
    # on linux. So we have to stub out the dir or cp the prebuilt files.
    mkdir -p ./dist
    for arch in x64 arm64; do
      src_dir="./node_modules/@vencord/venmic/prebuilds/venmic-addon-darwin-$arch"
      if [ -d "$src_dir" ]; then
        cp "$src_dir"/*.node "./dist/venmic-$arch.node"
      else
        : > "./dist/venmic-$arch.node"
      fi
    done

    # electron tries to modify electron.dist, but this is in /nix/store, so make a
    # tmp version and use that.
    electronDist=$(mktemp -d)/electron
    mkdir -p "$electronDist"
    cp -R "${electron.dist}/." "$electronDist/"
    chmod -R u+w "$electronDist"

    pnpm exec electron-builder \
      --mac dir \
      --config.electronDist="$electronDist" \
      --config.electronVersion="${electron.version}" \
      --config.mac.identity=null \
      --config.mac.notarize=false

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    # electron-builder writes to dist/mac or dist/mac-arm64 depending on host arch
    app_src=$(find ./dist -maxdepth 2 -name "Legcord.app" -print -quit)
    if [ -z "$app_src" ]; then
      echo "error: Legcord.app not found in ./dist" >&2
      exit 1
    fi
    cp -R "$app_src" "$out/Applications/Legcord.app"

    # This $out gets redirected by home-manager.
    # End up here: `/Users/*/Applications/Home\ Manager\ Apps/`
    makeWrapper "$out/Applications/Legcord.app/Contents/MacOS/Legcord" "$out/bin/legcord"

    runHook postInstall
  '';

  passthru = {
    inherit (finalAttrs) pnpmDeps;
  };

  meta = {
    description = "Lightweight, alternative desktop client for Discord (darwin build)";
    homepage = "https://legcord.app";
    license = lib.licenses.osl3;
    platforms = lib.platforms.darwin;
    mainProgram = "legcord";
  };
})
