{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.hardware.nvidia-gpu;
in
{
  options.deeznuts.hardware.nvidia-gpu = {
    enable = mkEnableOption "Enable nvidia gpu";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics.enable = true;
    hardware.nvidia.open = true;
    hardware.nvidia.modesetting.enable = true;
  };
}
