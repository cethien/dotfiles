{ pkgs, lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.hardware.stream-deck;
in
{
  options.deeznuts.hardware.stream-deck = {
    enable = mkEnableOption "Enable stream deck";
  };

  config = mkIf cfg.enable {
    programs.streamcontroller.enable = true;
  };
}
