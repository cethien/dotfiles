{ lib, config, ... }:

{
  options.deeznuts.hardware.nvidia-gpu.enable = lib.mkEnableOption "Enable Nvidia GPU support";

  config = lib.mkIf config.deeznuts.hardware.nvidia-gpu.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics.enable = true;
    hardware.nvidia.open = true;
    hardware.nvidia.modesetting.enable = true;
  };
}
