{ a, ... }:
{
  our.nix-config.includes = [ a.starship ];

  a.starship.homeManager =
    { config, lib, ... }:
    {
      programs.starship.enable = true;
      programs.starship = {
        configPath = "${config.xdg.configHome}/starship/starship.toml";
        enableZshIntegration = true;
        settings = {
          add_newline = true;
          format = lib.concatStrings [
            "$username@$hostname [in](italic dimmed white) $directory ([on](italic dimmed white) $git_branch) $git_status $fill $time"
            "$line_break"
            "$character"
          ];
          character = {
            success_symbol = "[>](bold green) \\$";
            error_symbol = "[>](bold red) x";
          };
          directory = {
            format = "[$path](bold white)";
            truncation_length = 8;
          };
          fill.symbol = " ";
          git_branch = {
            format = "[$branch(:$remote_branch)](dimmed underline white)";
            truncation_length = 29;
          };
          git_status = {
            format = "([\\[$all_status$ahead_behind\\]]($style))";
            conflicted = "><";
            behind = "<";
            ahead = ">";
            up_to_date = "-";
            untracked = "?";
            staged = "[++\\([$count](style))]";
          };
          hostname = {
            format = "[$hostname](dimmed white)";
            ssh_only = false;
          };
          time = {
            format = "[$time](white)";
            disabled = false;
            time_format = "%Y-%m-%dT%H:%M:%S%z";
          };
          username = {
            format = "[$user](white)";
            show_always = true;
          };
        };
      };

      home.sessionVariables.STARSHIP_LOG = "error";
    };
}
