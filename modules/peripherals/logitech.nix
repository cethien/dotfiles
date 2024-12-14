{ pkgs, lib, config, ... }:

{
  options.peripherals.logitech.enable = lib.mkEnableOption "Enable Logitech peripherals";

  config = lib.mkIf config.peripherals.logitech.enable {
    hardware.logitech.wireless.enable = true;
    environment.systemPackages = with pkgs; [
        solaar    
    ];
  };
}