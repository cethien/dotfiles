{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.programs.r2modman.enable = mkEnableOption "r2modmanager";

  config = {
    home.packages = [pkgs.r2modman];
  };
}
