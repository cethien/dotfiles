{
  lib,
  config,
  ...
}:
with lib; {
  config = mkIf (elem "nvidia" config.deeznuts.hardware) {
    services.xserver.videoDrivers = ["nvidia"];
    hardware.graphics.enable = true;
    hardware.nvidia = {
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
