{ system, ... }:

{
  imports = [
    ./print.nix
    ./logitech.nix
    ./xbox-controller.nix
    ./stream-deck.nix
  ];

  logitech.enable = !system.profile.isPortableDevice;
  xbox.enable = !system.profile.isPortableDevice;
  streamdeck.enable = !system.profile.isPortableDevice;
}