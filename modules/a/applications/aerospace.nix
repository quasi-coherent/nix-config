{a, ...}: {
  a.aerospace.darwin = {
    services = {
      aerospace = {
        enable = true;

        settings = {
          automatically-unhide-macos-hidden-apps = true;
          config-version = 2;
          enable-normalization-flatten-containers = true;
          enable-normalization-opposite-orientation-for-nested-containers = true;

          gaps = {
            inner = {
              horizontal = 0;
              vertical = 0;
            };

            outer = {
              bottom = 0;
              left = 0;
              right = 0;
              top = 0;
            };
          };

          mode.main.binding = {
            cmd-alt-leftSquareBracket = "workspace-back-and-forth";
            cmd-alt-rightSquareBracket = "move-workspace-to-monitor --wrap-around next";
            cmd-comma = "layout accordion horizontal vertical";
            cmd-down = "focus --boundaries-action wrap-around-the-workspace down";
            cmd-left = "focus --boundaries-action wrap-around-the-workspace left";
            cmd-right = "focus --boundaries-action wrap-around-the-workspace right";
            cmd-shift-1 = "move-node-to-workspace T";
            cmd-shift-2 = "move-node-to-workspace B";
            cmd-shift-3 = "move-node-to-workspace W";
            cmd-shift-4 = "move-node-to-workspace M";
            cmd-shift-5 = "move-node-to-workspace S";
            cmd-shift-6 = "move-node-to-workspace L";
            cmd-shift-down = "move down";
            cmd-shift-left = "move left";
            cmd-shift-right = "move right";
            cmd-shift-space = "layout floating tiling";
            cmd-shift-up = "move up";
            cmd-slash = "layout tiles horizontal vertical";
            cmd-up = "focus --boundaries-action wrap-around-the-workspace up";
            ctrl-cmd-down = "join-with down";
            ctrl-cmd-left = "join-with left";
            ctrl-cmd-right = "join-with right";
            ctrl-cmd-up = "join-with up";
          };

          workspace-to-monitor-force-assignment = {
            B = 1;
            L = 3;
            M = 1;
            S = 2;
            T = 1;
            W = 1;
          };
        };
      };
    };
  };

  # I think it's impossible to come up with usable keybindings.
  our.disabled.includes = [a.aerospace];
}
