{ a, den, ... }:
{
  flake-file.inputs = {
    claude = {
      url = "github:sadjow/claude-code-nix?ref=v2.1.218";
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
        claudeCode = inputs'.claude.packages.claude-code;
      in
      {
        imports = [ (import ./_claude { inherit claudeCode; }) ];

        nix-config.programs.claude =
          let
            defaultDeny = [
              # I don't even have these; cannot understand why it continues to
              # try to use things not even available on the path.
              "Bash(python3)"
              "Bash(gh)"

              "Bash(sops*)"
              "Bash(age*)"
              "Bash(cachix*)"
              "Bash(aws*)"
              "Bash(git push *)"
              "Bash(nix profile *)"
              "Bash(* install)"
            ];
          in
          {
            claudep.permissions.deny = defaultDeny ++ [
              "Bash(git commit *)"
            ];
            claudecs.permissions.deny = defaultDeny;
          };
      };
  };
}
