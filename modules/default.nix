{ ... }:

{
  imports = [
    ./user.nix    
    ./audio.nix    

    ./docker.nix
    ./virtualization.nix
    
    ./gaming
    
    ./peripherals
    ./desktop.nix
  ];
}