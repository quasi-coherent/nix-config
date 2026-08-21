{ a, ... }:
{
  a.lua.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        lua
        lua-language-server
        luaformatter
      ];
    };

  our.nix-config.includes = [ a.lua ];
}
