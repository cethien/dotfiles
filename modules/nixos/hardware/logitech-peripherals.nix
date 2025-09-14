{
  lib,
  config,
  ...
}:
with lib; {
  config = mkIf (elem "logitech" config.deeznuts.hardware) {
    hardware.logitech.wireless.enable = true;
  };
}
