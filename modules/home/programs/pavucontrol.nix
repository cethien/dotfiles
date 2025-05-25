{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.pavucontrol;
in
{
  options.deeznuts.programs.pavucontrol = {
    enable = mkEnableOption "Enable pavucontrol";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ pavucontrol ];
  };
}
