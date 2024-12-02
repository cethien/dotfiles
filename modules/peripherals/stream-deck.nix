{ pkgs, lib, config, ... }:

{
  options.streamdeck.enable = lib.mkEnableOption "Enable Streamdeck peripherals";

  config = lib.mkIf config.streamdeck.enable {
        environment.systemPackages = with pkgs; [      
        streamcontroller
    ];
  };
}