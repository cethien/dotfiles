{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) str;
  cfg = config.deeznuts.user;
in
{
  options.deeznuts.user = {
    enable = mkEnableOption "Enable user settings";

    name = mkOption {
      type = str;
      default = "cethien";
      description = "The user name to use for home-manager";
    };
  };

  config = mkIf cfg.enable {
    home.username = cfg.name;
    home.homeDirectory = "/home/${cfg.name}";
  };
}
