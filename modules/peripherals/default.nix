{ system, ... }:

{
  imports = [
    ./print.nix
    ./logitech.nix
    ./xbox-controller.nix
    ./stream-deck.nix
  ];

  logitech.enable = system.profile.isHomePC;
  xbox.enable = system.profile.isHomePC;
  streamdeck.enable = system.profile.isHomePC;
}