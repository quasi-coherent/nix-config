{ a, ... }:
{
  a.starship.homeManager =
    {
      config,
      lib,
      ...
    }:
    {
      home.sessionVariables.STARSHIP_LOG = "error";

      programs = {
        starship = {
          configPath = "${config.xdg.configHome}/starship/starship.toml";
          enableZshIntegration = true;

          settings = {
            add_newline = true;

            character = {
              error_symbol = "[>](bold red) x";
              success_symbol = "[>](bold green) \\$";
            };

            directory = {
              format = "[$path](bold white)";
              truncation_length = 8;
            };

            fill.symbol = " ";

            format = lib.concatStrings [
              "$username@$hostname [in](italic dimmed white) $directory ([on](italic dimmed white) $git_branch) $git_status $fill $time"
              "$line_break"
              "$character"
            ];

            git_branch = {
              format = "[$branch(:$remote_branch)](dimmed underline white)";
              truncation_length = 29;
            };

            git_status = {
              ahead = ">";
              behind = "<";
              conflicted = "><";
              format = "([\\[$all_status$ahead_behind\\]]($style))";
              staged = "[++\\([$count](style))]";
              untracked = "?";
              up_to_date = "-";
            };

            hostname = {
              format = "[$hostname](dimmed white)";
              ssh_only = false;
            };

            time = {
              disabled = false;
              format = "[$time](white)";
              time_format = "%Y-%m-%dT%H:%M:%S%z";
            };

            username = {
              format = "[$user](white)";
              show_always = true;
            };
          };
        };

        starship.enable = true;
      };
    };

  our.nix-config.includes = [ a.starship ];
}
