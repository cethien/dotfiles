{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.ardour;
in {
  options.programs.ardour = {
    enable = mkEnableOption "enable ardour";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ardour

      vital
    ];
  };
}
