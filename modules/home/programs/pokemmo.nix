{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.pokemmo;
in
{
  options.deeznuts.programs.pokemmo = {
    enable = mkEnableOption "pokemmo";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pokemmo-installer
    ];

    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace 6, title:^(pokemmo)$"
      ];
    };
  };
}
