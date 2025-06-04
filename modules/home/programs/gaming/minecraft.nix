{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.gaming.minecraft;
in {
  options.deeznuts.programs.gaming.minecraft = {
    enable = mkEnableOption "minecraft 🧱";
    hyprland.workspace = mkOption {
      type = types.int;
      default = config.deeznuts.programs.hyprland.defaultWorkspaces.gaming;
      description = "default hyprland workspace";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [prismlauncher];
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:org.prismlauncher.PrismLauncher"
        "workspace ${toString cfg.hyprland.workspace}, class:^Minecraft.*"
        "fullscreen, class:^Minecraft.*"
      ];
    };
  };
}
