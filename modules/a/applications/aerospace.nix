{ a, ... }:
{
  # I think it's impossible to come up with usable keybindings.
  our.disabled.includes = [ a.aerospace ];

  a.aerospace.darwin = {
    services.aerospace.enable = true;
    services.aerospace.settings = {
      config-version = 2;
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      automatically-unhide-macos-hidden-apps = true;
      gaps = {
        inner.horizontal = 0;
        inner.vertical = 0;
        outer.left = 0;
        outer.bottom = 0;
        outer.top = 0;
        outer.right = 0;
      };
      mode.main.binding = {
        cmd-left = "focus --boundaries-action wrap-around-the-workspace left";
        cmd-down = "focus --boundaries-action wrap-around-the-workspace down";
        cmd-up = "focus --boundaries-action wrap-around-the-workspace up";
        cmd-right = "focus --boundaries-action wrap-around-the-workspace right";

        cmd-shift-left = "move left";
        cmd-shift-down = "move down";
        cmd-shift-up = "move up";
        cmd-shift-right = "move right";
        cmd-shift-1 = "move-node-to-workspace T";
        cmd-shift-2 = "move-node-to-workspace B";
        cmd-shift-3 = "move-node-to-workspace W";
        cmd-shift-4 = "move-node-to-workspace M";
        cmd-shift-5 = "move-node-to-workspace S";
        cmd-shift-6 = "move-node-to-workspace L";

        ctrl-cmd-left = "join-with left";
        ctrl-cmd-down = "join-with down";
        ctrl-cmd-up = "join-with up";
        ctrl-cmd-right = "join-with right";

        cmd-slash = "layout tiles horizontal vertical";
        cmd-comma = "layout accordion horizontal vertical";
        cmd-shift-space = "layout floating tiling";

        cmd-alt-leftSquareBracket = "workspace-back-and-forth";
        cmd-alt-rightSquareBracket = "move-workspace-to-monitor --wrap-around next";
      };
      workspace-to-monitor-force-assignment = {
        T = 1;
        B = 1;
        W = 1;
        M = 1;
        S = 2;
        L = 3;
      };
    };
  };
}
