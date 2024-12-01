{ pkgs, ... }:

{
  hardware.xpadneo.enable = true;
  hardware.logitech.wireless.enable = true;

  # printing
  services.printing.enable = true;

  environment.systemPackages = with pkgs; [
      solaar # logitech
      
      streamcontroller # streamdeck
      gnomeExtensions.streamcontroller-integration
  ];
}