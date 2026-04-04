{ a, ... }:
{
  our.nix-config.includes = [ a.lua ];

  a.lua.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        lua
        lua-language-server
        luaformatter
      ];
    };
}
