{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.apps-creative;
in {
  options.programs.apps-creative.enable = lib.mkEnableOption "basic creative apps";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pinta
      gimp
      inkscape
      # ocenaudio
    ];
  };
}
