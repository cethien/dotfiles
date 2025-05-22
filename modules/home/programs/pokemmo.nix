{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.deeznuts.programs.pokemmo;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs.pokemmo = {
    enable = mkEnableOption "pokemmo";
    hyprland.workspace = mkOption {
      type = types.int;
      default = config.deeznuts.programs.hyprland.defaultWorkspaces.gaming;
      description = "default hyprland workspace";
    };
  };

  config = mkIf enabled {
    home.packages = with pkgs; [
      pokemmo-installer
    ];

    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, title:PokeMMO"
        "fullscreen, title:PokeMMO"
      ];
    };
  };
}
