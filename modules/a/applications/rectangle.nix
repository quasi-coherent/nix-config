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
    # See documentation: https://github.com/rxhanson/Rectangle/blob/main/TerminalCommands.md
    # Key code reference: https://eastmanreference.com/complete-list-of-applescript-key-codes
    darwin.system.defaults.CustomUserPreferences."com.knollsoft.Rectangle" = {
      allowAnyShortcut = 1;

      # Should be equal to sketchybar's background.height.
      screenEdgeGapTop = 30;

      maximize = {
        keyCode = 36;
        modifierFlags = 1179648;
      };

      bottomHalf = {
        keyCode = 125;
        modifierFlags = 1179648;
      };

      bottomLeft = {
        keyCode = 38;
        modifierFlags = 1179648;
      };

      bottomRight = {
        keyCode = 40;
        modifierFlags = 1179648;
      };

      center = {
        keyCode = 8;
        modifierFlags = 1179648;
      };

      larger = {
        keyCode = 24;
        modifierFlags = 1179648;
      };

      leftHalf = {
        keyCode = 123;
        modifierFlags = 1179648;
      };

      nextDisplay = {
        keyCode = 124;
        modifierFlags = 1703936;
      };

      previousDisplay = {
        keyCode = 123;
        modifierFlags = 1703936;
      };

      restore = {
        keyCode = 51;
        modifierFlags = 1179648;
      };

      rightHalf = {
        keyCode = 124;
        modifierFlags = 1179648;
      };

      smaller = {
        keyCode = 27;
        modifierFlags = 1179648;
      };

      topHalf = {
        keyCode = 126;
        modifierFlags = 1179648;
      };

      topLeft = {
        keyCode = 32;
        modifierFlags = 1179648;
      };

      topRight = {
        keyCode = 34;
        modifierFlags = 1179648;
      };
    };
  };
}
