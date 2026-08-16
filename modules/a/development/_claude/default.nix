{claudeCode}: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkOption
    mkEnableOption
    mkDefault
    types
    attrValues
    filterAttrs
    filterAttrsRecursive
    mapAttrs'
    nameValuePair
    ;
  cfg = config.nix-config.programs.claude;
  claudeInstance = {
    config,
    name,
    ...
  }: {
    options = {
      enable =
        mkEnableOption "this Claude Code instance"
        // {
          default = true;
        };

      package = mkOption {
        description = "The `claude` wrapper bound to this instance's config dir.";
        internal = true;
        type = types.package;
      };

      configDir = mkOption {
        description = "Absolute path to this instance's CLAUDE_CONFIG_DIR.";
        type = types.str;
      };

      defaultMode = mkOption {
        default = "default";
        description = "Default permission mode.";

        type = types.enum [
          "default"
          "acceptEdits"
          "plan"
          "auto"
        ];
      };

      effortLevel = mkOption {
        default = "high";
        description = "Default effort.";

        type = types.enum [
          "low"
          "medium"
          "high"
          "xhigh"
          "max"
        ];
      };

      env = mkOption {
        default = {};
        description = "Environment variables applied to every session.";
        type = types.attrsOf types.str;
      };

      extraSettings = mkOption {
        default = {};
        description = "Freeform attributes merged into (and overriding) settings.json.";
        type = types.attrsOf types.raw;
      };

      model = mkOption {
        default = "opus";
        description = "Default model.";

        type = types.enum [
          "haiku"
          "opus"
          "sonnet"
        ];
      };

      permissions = {
        allow = mkOption {
          default = [];
          description = "List of allow rules.";
          type = types.listOf types.str;
        };

        deny = mkOption {
          default = [];
          description = "List of deny rules.";
          type = types.listOf types.str;
        };
      };

      settings = mkOption {
        description = "The assembled attrset serialized to settings.json.";
        internal = true;
        type = types.attrsOf types.raw;
      };

      settingsFile = mkOption {
        description = "The rendered settings.json in the store.";
        internal = true;
        type = types.package;
      };

      theme = mkOption {
        default = "auto";
        description = "Color theme for the interface.";
        type = types.str;
      };

      tui = mkOption {
        default = "default";
        description = "Terminal UI renderer.";

        type = types.enum [
          "default"
          "fullscreen"
        ];
      };
    };

    config = {
      package = pkgs.callPackage ./package.nix {
        inherit name claudeCode;
        inherit (config) configDir;
      };

      configDir = mkDefault "${hmConfig.xdg.configHome}/claude-${name}";

      settings = filterAttrsRecursive (_: v: v != null) (
        {
          inherit
            (config)
            model
            theme
            tui
            env
            ;

          permissions = {
            inherit (config.permissions) allow deny;
            inherit (config) defaultMode;
          };
        }
        // config.extraSettings
      );

      settingsFile = pkgs.writeText "claude-${name}-settings.json" (builtins.toJSON config.settings);
    };
  };
  hmConfig = config;
in {
  options.nix-config.programs.claude = mkOption {
    default = {};
    description = "Configure a claude-code instance.";
    type = types.attrsOf (types.submodule claudeInstance);
  };

  config = let
    enabled = filterAttrs (_: i: i.enable) cfg;
  in {
    home.packages = map (i: i.package) (attrValues enabled);

    xdg.configFile =
      mapAttrs' (
        name: i: nameValuePair "claude-${name}/settings.json" {source = i.settingsFile;}
      )
      enabled;
  };
}
