{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.mixxx;
in {
  options.deeznuts.programs.mixxx = {
    enable = mkEnableOption "mixxx dj software";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mixxx
    ];
  };
}
