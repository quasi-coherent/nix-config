{
  my.shortcuts.homeManager = {config, ...}: {
    programs.zsh = {
      dirHashes = {
        cfg = "${config.home.homeDirectory}/nix-config";
        dd = "${config.home.homeDirectory}/dd";
        ghub = "${config.home.homeDirectory}/dd/git/hub";
        glab = "${config.home.homeDirectory}/dd/git/lab";
        vc = "${config.home.homeDirectory}/dd/git";
      };

      shellAliases = {
        cdc = "cd ~cfg";
        cdd = "cd ~dd";
        cdg = "cd ~vc";
        cdgh = "cd ~ghub";
        cdgl = "cd ~glab";
      };
    };

    xdg.userDirs.extraConfig.DD = "${config.home.homeDirectory}/dd";
  };
}
