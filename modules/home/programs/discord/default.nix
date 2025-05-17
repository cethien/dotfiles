{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf types mkOption;
  cfg = config.deeznuts.programs.discord;
  cfgHyprland = config.deeznuts.programs.hyprland.programs.discord;
in
{
  options.deeznuts.programs = {
    discord.enable = mkEnableOption "discord";

    hyprland.programs.discord = {
      autostart = {
        enable = mkEnableOption "enable autostart";
        workspace = mkOption {
          type = types.int;
          default = 3;
          description = "Workspace for autostart";
        };
      };
    };

  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfgHyprland.autostart.enable [
        "[workspace ${toString cfgHyprland.autostart.workspace} silent] discord --start-minimized"
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
