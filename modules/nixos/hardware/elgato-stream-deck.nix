{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.hardware.elgato-stream-deck;
in {
  options.deeznuts.hardware.elgato-stream-deck = {
    enable = mkEnableOption "elgato stream deck";
  };

  config = mkIf cfg.enable {
    programs.streamcontroller.enable = true;
  };
}
