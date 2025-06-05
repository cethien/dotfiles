{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.hardware.logitech-peripherals;
in {
  options.deeznuts.hardware.logitech-peripherals = {
    enable = mkEnableOption "logitech peripherals";
  };

  config = mkIf cfg.enable {
    hardware.logitech.wireless.enable = true;
    environment.systemPackages = with pkgs; [solaar];
  };
}
