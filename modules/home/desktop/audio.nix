{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.programs.desktop.isEnabled {
    home.packages = with pkgs; [
      wiremix
    ];
  };
}
