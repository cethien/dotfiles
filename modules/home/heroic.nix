{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.heroic;
in {
  options.programs.heroic.enable = mkEnableOption "heroic launcher";

  config = mkIf cfg.enable {
    home.packages = [pkgs.heroic];
  };
}
