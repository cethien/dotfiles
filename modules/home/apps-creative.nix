{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.apps-creative;
in {
  options.programs.apps-creative.enable = lib.mkEnableOption "basic creative apps";

  config = {
    home.packages = lib.mkIf cfg.enable (with pkgs; [
      pinta
      gimp
      inkscape
      # ocenaudio
    ]);
  };
}
