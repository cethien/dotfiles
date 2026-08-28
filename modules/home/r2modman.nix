{
  config,
  lib,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.programs.r2modman;
in {
  options.programs.r2modman.enable = mkEnableOption "r2modmanager";

  config = mkIf cfg.enable {
    home.packages = [pkgs-unstable.r2modman];
  };
}
