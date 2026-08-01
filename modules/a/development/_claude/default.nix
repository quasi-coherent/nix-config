{ claudeCode }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
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

  hmConfig = config;

  cfg = config.nix-config.programs.claude;

  claudeInstance =
    {
      config,
      name,
      ...
    }:
    {
      options = {
        enable = mkEnableOption "this Claude Code instance" // {
          default = true;
        };
        model = mkOption {
          type = types.enum [
            "haiku"
            "opus"
            "sonnet"
          ];
          default = "opus";
          description = "Default model.";
        };
        effortLevel = mkOption {
          type = types.enum [
            "low"
            "medium"
            "high"
            "xhigh"
            "max"
          ];
          default = "high";
          description = "Default effort.";
        };
        defaultMode = mkOption {
          type = types.enum [
            "default"
            "acceptEdits"
            "plan"
            "auto"
          ];
          default = "default";
          description = "Default permission mode.";
        };
        theme = mkOption {
          type = types.str;
          default = "auto";
          description = "Color theme for the interface.";
        };
        tui = mkOption {
          type = types.enum [
            "default"
            "fullscreen"
          ];
          default = "default";
          description = "Terminal UI renderer.";
        };
        env = mkOption {
          type = types.attrsOf types.str;
          default = { };
          description = "Environment variables applied to every session.";
        };
        permissions = {
          allow = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "List of allow rules.";
          };
          deny = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "List of deny rules.";
          };
        };
        extraSettings = mkOption {
          type = types.attrsOf types.raw;
          default = { };
          description = "Freeform attributes merged into (and overriding) settings.json.";
        };

        configDir = mkOption {
          type = types.str;
          description = "Absolute path to this instance's CLAUDE_CONFIG_DIR.";
        };

        settings = mkOption {
          type = types.attrsOf types.raw;
          internal = true;
          description = "The assembled attrset serialized to settings.json.";
        };

        settingsFile = mkOption {
          type = types.package;
          internal = true;
          description = "The rendered settings.json in the store.";
        };

        package = mkOption {
          type = types.package;
          internal = true;
          description = "The `claude` wrapper bound to this instance's config dir.";
        };
      };

      config = {
        configDir = mkDefault "${hmConfig.xdg.configHome}/claude-${name}";

        settings = filterAttrsRecursive (_: v: v != null) (
          {
            inherit (config)
              model
              theme
              env
              ;
            permissions = {
              inherit (config.permissions) allow deny;
              defaultMode = config.defaultMode;
            };
          }
          // config.extraSettings
        );

        settingsFile = pkgs.writeText "claude-${name}-settings.json" (builtins.toJSON config.settings);

        package = pkgs.callPackage ./package.nix {
          inherit name claudeCode;
          inherit (config) configDir;
        };
      };
    };
in
{
  options.nix-config.programs.claude = mkOption {
    type = types.attrsOf (types.submodule claudeInstance);
    default = { };
    description = "Configure a claude-code instance.";
  };

  config =
    let
      enabled = filterAttrs (_: i: i.enable) cfg;
    in
    {
      home.packages = map (i: i.package) (attrValues enabled);

      xdg.configFile = mapAttrs' (
        name: i: nameValuePair "claude-${name}/settings.json" { source = i.settingsFile; }
      ) enabled;
    };
}
