{ pkgs, lib, config, ... }:

{
  options.deeznuts.hardware.stream-deck.enable = lib.mkEnableOption "Enable Streamdeck peripherals";

  config = lib.mkIf config.deeznuts.hardware.stream-deck.enable {
    environment.systemPackages = with pkgs; [ streamcontroller ];
  };
}
