{ ... }:

{
  imports = [
    ./users
    ./ssh.nix
    ./audio    

    ./docker.nix
    ./virtualization.nix
    
    ./gaming
    
    ./peripherals
    ./desktop.nix
  ];
}
