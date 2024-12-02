{ system, ... }:

{
  imports = [
    ./sh
    ./dev    
    ./customization
    ./apps
    ./gaming.nix
  ];

  user.gaming.enable = system.profile.isHomePC; 
  user.apps.enable = system.profile.isNixos;
}