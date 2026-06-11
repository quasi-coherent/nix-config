{ a, den, ... }:
{
  flake-file.inputs = {
    claude = {
      url = "github:sadjow/claude-code-nix?ref=v2.1.71";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  our.nix-config.includes = [ a.claude ];

  a.claude = {
    includes = [
      (den.batteries.unfree [ "claude-code" ])
    ];

    homeManager =
      { inputs', ... }:
      let
        claude = inputs'.claude.packages.claude-code;
      in
      {
        home.packages = [ claude ];
      };
  };
}
