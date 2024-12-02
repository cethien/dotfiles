{ pkgs, lib, config, ... }:

{
  options.logitech.enable = lib.mkEnableOption "Enable Logitech peripherals";

  config = lib.mkIf config.logitech.enable {
    hardware.logitech.wireless.enable = true;
    environment.systemPackages = with pkgs; [
        solaar    
    ];
  };
}