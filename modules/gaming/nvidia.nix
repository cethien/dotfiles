{ lib, config, ... }:

{
  options.gaming.nvidia.enable = lib.mkEnableOption "Enable Nvidia GPU support";

  config = lib.mkIf config.gaming.nvidia.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = true;
    hardware.nvidia.modesetting.enable = true;
  };
}
