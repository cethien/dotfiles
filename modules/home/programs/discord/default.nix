{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf types mkOption;
  cfg = config.deeznuts.programs.discord;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs.discord = {
    enable = mkEnableOption "discord";
    hyprland = {
      autostart.enable = mkEnableOption "enable autostart";
      workspace = mkOption {
        type = types.int;
        default = 4;
        description = "default workspace";
      };
    };
  };

  config = mkIf enabled {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:^(discord)$"
        "workspace ${toString cfg.hyprland.workspace}, class:^(vesktop)$"
      ];
      exec-once = mkIf cfg.hyprland.autostart.enable [
        "[silent] discord --start-minimized"
      ];
    };

    home.packages = with pkgs; [
      vesktop
      # (discord.override {
      # withVencord = true;
      # withOpenASAR = true;
      # })
    ];
  };
}
