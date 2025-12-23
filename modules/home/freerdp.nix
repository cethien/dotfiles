{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.programs.freerdp;

  # This set defines all available RDP options.
  # It's the single source of truth for option names, types, and descriptions.
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
    desktopWidth = {
      name = "desktopwidth";
      type = types.nullOr types.int;
      default = null;
      description = "The desktop width in pixels.";
    };
    desktopHeight = {
      name = "desktopheight";
      type = types.nullOr types.int;
      default = null;
      description = "The desktop height in pixels.";
    };
    disableWallpaper = {
      name = "disable wallpaper";
      type = types.bool;
      default = true;
      description = "Disable the wallpaper for performance.";
    };
    redirectPrinters = {
      name = "redirectprinters";
      type = types.bool;
      default = false;
      description = "Redirect local printers to the remote machine.";
    };
    redirectClipboard = {
      name = "redirectclipboard";
      type = types.bool;
      default = true;
      description = "Redirect clipboard.";
    };
    spanMonitors = {
      name = "span monitors";
      type = types.bool;
      default = false;
      description = "Span across multiple monitors.";
    };
    multiMonitor = {
      name = "use multimon";
      type = types.bool;
      default = false;
      description = "Use multiple monitors.";
    };
    dynamicResolution = {
      name = "dynamic resolution";
      type = types.bool;
      default = false;
      description = "The remote session will dynamically adjust to the size of the RDP window.";
    };
    ignoreCertificate = {
      name = "ignore certificate";
      type = types.bool;
      default = false;
      description = "Ignore the certificate of the RDP server, useful for self-signed certificates.";
    };
    authenticationLevel = {
      name = "authentication level";
      type = types.nullOr types.int;
      default = null;
      description = "Authentication level to use. 0: None, 1: Required, 2: NLA (default on Windows).";
    };
  };

  # Dynamically generate the connection submodule options from rdpOptions.
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
    # We only want to write attributes that the user has explicitly set
    # or that have a default value.
    # The `attrs` set contains all options, including those not set by the user,
    # which have `null` values.
    filteredAttrs = lib.filterAttrs (n: v: !isNull v) attrs;

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
            else null; # Should not happen due to type checking
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
      example = {
        "my-server" = {
          fullAddress = "server.example.com";
          username = "myuser";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      freerdp
    ];

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
