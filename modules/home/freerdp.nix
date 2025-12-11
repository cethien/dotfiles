{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.programs.freerdp;
  # connectionType = types.submodule {
  #   options = {
  #     "full address" = mkOption {
  #       type = types.str;
  #       description = "The RDP server address.";
  #     };
  #     "domain" = mkOption {
  #       type = types.str;
  #       description = "The RDP domain.";
  #     };
  #     "username" = mkOption {
  #       type = types.str;
  #       description = "The RDP username.";
  #     };
  #     "desktopwidth" = mkOption {
  #       type = types.int;
  #       default = 1600;
  #       description = "The desktop width in pixels.";
  #     };
  #     "desktopheight" = mkOption {
  #       type = types.int;
  #       default = 900;
  #       description = "The desktop height in pixels.";
  #     };
  #     "disable wallpaper" = mkOption {
  #       type = types.bool;
  #       default = true;
  #       description = "Sets 'disable wallpaper:i:1' or '0'.";
  #     };
  #   };
  # };
  #
  # generateRdpLine = k: v: let
  #   rdpSuffix =
  #     if lib.isType "int" v || lib.isType "bool" v
  #     then ":i:"
  #     else ":s:";
  #
  #   finalValue =
  #     if lib.isType "bool" v
  #     then
  #       if v
  #       then "1"
  #       else "0"
  #     else toString v;
  # in "${k}${rdpSuffix}${finalValue}\n";
in {
  options.programs.freerdp = {
    enable = mkEnableOption "Enable FreeRDP configuration and RDP file generation.";

    # connections = mkOption {
    #   type = types.attrsOf connectionType;
    #   default = {};
    #   description = ''
    #     Map of FreeRDP connection profiles.
    #     All required RDP attributes must be set for each connection.
    #   '';
    # };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      freerdp
      (writeShellScriptBin "rdpf" (builtins.readFile ./fzf-freerdp.sh))
    ];

    # TODO: doesnt work yet, parsing errors

    # home.file =
    #   lib.mapAttrs'
    #   (
    #     host: hostAttrs: let
    #       contents =
    #         lib.concatMapStrings
    #         (k: v: generateRdpLine k v)
    #         (lib.attrNames hostAttrs)
    #         hostAttrs;
    #     in {
    #       name = ".rdp/${host}.rdp";
    #       value = {
    #         text = contents;
    #       };
    #     }
    #   )
    #   cfg.connections;
  };
}
