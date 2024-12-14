{ pkgs, lib, config, ... }:

{
  options.peripherals.streamdeck.enable = lib.mkEnableOption "Enable Streamdeck peripherals";

  config = lib.mkIf config.peripherals.streamdeck.enable {
    environment.systemPackages = with pkgs; [
      streamcontroller
    ];
  };
}
