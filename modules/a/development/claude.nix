{
  a,
  den,
  ...
}: {
  a.claude = {
    includes = [
      (den.batteries.unfree ["claude-code"])
    ];

    homeManager = {inputs', ...}: let
      claudeCode = inputs'.claude.packages.claude-code;
    in {
      imports = [(import ./_claude {inherit claudeCode;})];

      nix-config.programs.claude = let
        settingsJson = {
          defaultMode = "default";
          effortLevel = "high";
          model = "sonnet";

          permissions.deny = [
            # I don't even have these; cannot understand why it continues to
            # try to use things not even available on the path.
            "Bash(python3)"
            "Bash(gh)"

            "Bash(sops*)"
            "Bash(age*)"
            "Bash(cachix*)"
            "Bash(aws*)"
            "Bash(git commit *)"
            "Bash(git push *)"
            "Bash(nix profile *)"
            "Bash(* install)"
          ];

          theme = "auto";
          tui = "default";
        };
      in {
        claudecs = settingsJson;
        claudep = settingsJson;
      };
    };
  };

  our.nix-config.includes = [a.claude];
}
