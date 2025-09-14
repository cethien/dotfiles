{
  lib,
  config,
  ...
}:
with lib; {
  config = mkIf (elem "elgato-steam-deck" config.deeznuts.hardware) {
    programs.streamcontroller.enable = true;
  };
}
