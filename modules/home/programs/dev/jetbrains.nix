{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.deeznuts.programs.jetbrains;
in
{
  options.deeznuts.programs.jetbrains = {
    idea.enable = mkEnableOption "Jetbrains IntelliJ Community IDE";
    rider.enable = mkEnableOption "Jetbrains Rider IDE";
  };

  config = {
    home.packages = mkMerge [
      (mkIf cfg.idea.enable [ pkgs.jetbrains.idea-community ])
      (mkIf cfg.rider.enable [ pkgs.jetbrains.rider ])
    ];
  };
}
