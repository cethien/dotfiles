{ pkgs, lib, config, ... }:

{
  options.hardware.stream-deck.enable = lib.mkEnableOption "Enable Streamdeck peripherals";

  config = lib.mkIf config.hardware.stream-deck.enable {
    environment.systemPackages = with pkgs; [ streamcontroller ];
  };
}
