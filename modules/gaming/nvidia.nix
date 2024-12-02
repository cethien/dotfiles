{ lib, config, ... }:

{
  options.nvidia.enable = lib.mkEnableOption "Enable Nvidia GPU support";

  config = lib.mkIf config.nvidia.enable {
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.open = true;
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}