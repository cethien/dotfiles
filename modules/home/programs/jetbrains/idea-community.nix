{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.jetbrains.idea-community;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs.jetbrains.idea-community = {
    enable = mkEnableOption "jetbrains IntelliJ IDEA";
  };

  config = mkIf enabled {
    home.packages = with pkgs; [
      jetbrains.idea-community
    ];
  };
}
