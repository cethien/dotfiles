{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.termshark;
in
{
  options.deeznuts.programs.termshark = {
    enable = mkEnableOption "Enable termshark";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tshark
      termshark
    ];
  };
}
