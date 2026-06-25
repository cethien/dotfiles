{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.programs.freerdp;

  rdpOptions = {
    fullAddress = {
      name = "full address";
      type = types.str;
      description = "The RDP server address.";
    };
    domain = {
      name = "domain";
      type = types.nullOr types.str;
      default = null;
      description = "The RDP domain.";
    };
    username = {
      name = "username";
      type = types.nullOr types.str;
      default = null;
      description = "The RDP username.";
    };
  };

  connectionType = types.submodule {
    options =
      lib.mapAttrs'
      (name: optionDef:
        lib.nameValuePair name (mkOption (
          {
            inherit (optionDef) type description;
          }
          // (
            if builtins.hasAttr "default" optionDef
            then {default = optionDef.default;}
            else {}
          )
        )))
      rdpOptions;
  };

  generateRdpFileContent = attrs: let
    filteredAttrs = lib.filterAttrs (n: v: v != null) attrs;

    lines =
      lib.mapAttrsToList (
        name: value: let
          optionDef = rdpOptions.${name};
          rdpName = optionDef.name;
          rdpValue =
            if builtins.isBool value
            then "i:${
              if value
              then "1"
              else "0"
            }"
            else if builtins.isInt value
            then "i:${toString value}"
            else if builtins.isString value
            then "s:${value}"
            else null;
        in
          assert rdpValue != null; "${rdpName}:${rdpValue}"
      )
      filteredAttrs;
  in
    lib.concatStringsSep "\n" lines + "\n";
in {
  options.programs.freerdp = {
    enable = mkEnableOption "Enable FreeRDP configuration and RDP file generation.";

    connections = mkOption {
      type = types.attrsOf connectionType;
      default = {};
      description = ''
        A set of FreeRDP connection profiles.
        For each connection, a file will be created in `~/.rdp/`
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [freerdp];

    wayland.windowManager.hyprland.extraLuaFiles."99-freerdp" =
      #lua
      ''
        hl.window_rule({
            match = { initial_class = "^(.*freerdp.*)$" },
            tile  = true,
        })
      '';

    home.file =
      lib.attrsets.mapAttrs'
      (
        name: conn: {
          name = ".rdp/${name}.rdp";
          value.text = generateRdpFileContent conn;
        }
      )
      cfg.connections;
  };
}
