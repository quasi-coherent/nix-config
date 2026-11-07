{
  fetchFromGitHub,
  melpaBuild,
  polymode,
  yaml-mode,
}:
melpaBuild {
  pname = "poly-helm-mode";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "necaris";
    repo = "poly-helm-mode";
    rev = "38926c42aaa8ec41d16447b8ef31abf37ad8fa01";
    hash = "sha256-iTilFeWd1Mlg4OgmzE/ZXY/awhWgAC1CM1tbRKXtn14=";
  };

  packageRequires = [
    polymode
    yaml-mode
  ];
}
