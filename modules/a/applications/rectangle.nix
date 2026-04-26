{ a, ... }:
{
  our.nix-config.includes = [ a.rectangle ];

  a.rectangle = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.rectangle ];
      };

    # Options from Rectangle > Settings.
    #
    # Modifier keys (combinations are the sum of values):
    # * cmd: 1048576
    # * option: 524288
    # * ctrl: 262144
    # * shift: 131072
    # Activate multiple modifiers with the sum of their values, e.g.,
    # cmd+option+ctrl = 1835008
    # Key code reference: https://eastmanreference.com/complete-list-of-applescript-key-codes
    #
    # See documentation: https://github.com/rxhanson/Rectangle/blob/main/TerminalCommands.md
    darwin.system.defaults.CustomUserPreferences."com.knollsoft.Rectangle" = {
      allowAnyShortcut = 1;
      # I'll let the guy who made this manage launch agents.
      launchOnLogin = 1;

      # cmd+option+ctrl + N, M
      cascadeActiveApp = {
        keyCode = 45;
        modifierFlags = 1835008;
      };
      tileActiveApp = {
        keyCode = 46;
        modifierFlags = 1835008;
      };
      # cmd+option+ctrl+shift + N, M
      cascadeAll = {
        keyCode = 45;
        modifierFlags = 1966080;
      };
      tileAll = {
        keyCode = 46;
        modifierFlags = 1966080;
      };

      # cmd+option+ctrl + <del>
      restore = {
        keyCode = 51;
        modifierFlags = 1835008;
      };

      # cmd+option+ctrl + P, N
      nextDisplay = {
        keyCode = 35;
        modifierFlags = 1835008;
      };
      previousDisplay = {
        keyCode = 45;
        modifierFlags = 1835008;
      };

      # cmd+option+ctrl + <ret>
      maximize = {
        keyCode = 36;
        modifierFlags = 1835008;
      };
      # cmd+option+ctrl+shift + <ret>
      maximizeHeight = {
        keyCode = 36;
        modifierFlags = 1966080;
      };

      # cmd+option+ctrl + C
      center = {
        keyCode = 8;
        modifierFlags = 1835008;
      };

      # cmd+option+ctrl + F, G
      firstTwoThirds = {
        keyCode = 3;
        modifierFlags = 1835008;
      };
      lastThird = {
        keyCode = 5;
        modifierFlags = 1835008;
      };

      # cmd+option+ctrl + <left>, <down>, <up>, <right>
      leftHalf = {
        keyCode = 123;
        modifierFlags = 1835008;
      };
      bottomHalf = {
        keyCode = 125;
        modifierFlags = 1835008;
      };
      topHalf = {
        keyCode = 126;
        modifierFlags = 1835008;
      };
      rightHalf = {
        keyCode = 124;
        modifierFlags = 1835008;
      };

      # cmd+option+ctrl+shift + <left>, <down>, <up>, <right>
      topLeft = {
        keyCode = 123;
        modifierFlags = 1966080;
      };
      bottomLeft = {
        keyCode = 125;
        modifierFlags = 1966080;
      };
      topRight = {
        keyCode = 126;
        modifierFlags = 1966080;
      };
      bottomRight = {
        keyCode = 124;
        modifierFlags = 1966080;
      };
    };
  };
}
