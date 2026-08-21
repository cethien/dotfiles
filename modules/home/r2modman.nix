{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.programs.r2modman.enable = mkEnableOption "r2modmanager";

  config = {
    home.packages = [pkgs-unstable.r2modman];
  };
}
