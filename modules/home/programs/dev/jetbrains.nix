{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf mkMerge;
  cfg = config.deeznuts.programs.jetbrains;
in
{
  options.deeznuts.programs.jetbrains = {
    idea.enable = mkEnableOption "Jetbrains IntelliJ Community IDE";
    rider.enable = mkEnableOption "Jetbrains Rider IDE";
    hyprland.workspace = mkOption {
      type = types.int;
      default = config.deeznuts.programs.hyprland.defaultWorkspaces.development;
      description = "default hyprland workspace";
    };
  };

  config = {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:jetbrains-idea-ce"
        "workspace ${toString cfg.hyprland.workspace}, class:jetbrains-rider"
      ];
    };

    home.packages = mkMerge [
      (mkIf cfg.idea.enable [ pkgs.jetbrains.idea-community ])
      (mkIf cfg.rider.enable [ pkgs.jetbrains.rider ])
    ];
  };
}
