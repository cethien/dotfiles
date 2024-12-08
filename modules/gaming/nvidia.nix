{ lib, config, ... }:

{
  options.gaming.nvidia.enable = lib.mkEnableOption "Enable Nvidia GPU support";

  config = lib.mkIf config.gaming.nvidia.enable {
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.open = true;
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}