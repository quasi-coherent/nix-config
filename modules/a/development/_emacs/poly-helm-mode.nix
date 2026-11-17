{
  fetchFromGitHub,
  melpaBuild,
  polymode,
  yaml-mode,
}:
melpaBuild {
  packageRequires = [
    polymode
    yaml-mode
  ];
  pname = "poly-helm-mode";
  src = fetchFromGitHub {
    hash = "sha256-iTilFeWd1Mlg4OgmzE/ZXY/awhWgAC1CM1tbRKXtn14=";
    owner = "necaris";
    repo = "poly-helm-mode";
    rev = "38926c42aaa8ec41d16447b8ef31abf37ad8fa01";
  };
  version = "0.1.0";
}
