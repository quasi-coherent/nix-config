{ a, ... }:
{
  a.cpp.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        boost
        catch2
        ccls
        clang-tools
        cmake
        cmake-language-server
        ninja
      ];
    };

  our.nix-config.includes = [ a.cpp ];
}
