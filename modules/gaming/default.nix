{ system, ... }:

{
  imports = [
    ./nvidia.nix
    ./steam.nix
  ];

  gaming.nvidia.enable = system.profile.isHomePC;
  gaming.steam.enable = system.profile.isHomePC;
}