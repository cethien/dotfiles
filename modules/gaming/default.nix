{ system, ... }:

{
  imports = [
    ./nvidia.nix
    ./steam.nix
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  gaming.nvidia.enable = system.profile.isHomePC;
  gaming.steam.enable = system.profile.isHomePC;
}