{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.hardware.xbox-controller;
in
{
  options.deeznuts.hardware.xbox-controller = {
    enable = mkEnableOption "Enable xbox controller";
  };

  config = mkIf cfg.enable {
    hardware.xpadneo.enable = true;
  };
}
