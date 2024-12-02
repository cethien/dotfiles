{ system, ... }:

{
  imports = [
    ./sh
    ./dev    
    ./customization
    ./apps
    ./gaming.nix
  ];

  user.gaming.enable = !system.profile.isPortableDevice;
  user.apps = {
    enable = !system.profile.isWSL;
  };
}