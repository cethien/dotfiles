{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf elem;
  cfg = config.programs.discord;
  enabled = cfg.enable;
  hypr = elem "discord" config.wayland.windowManager.hyprland.autostart;
in {
  options.programs.discord = {
    enable = mkEnableOption "discord";
  };

  config = mkIf enabled {
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf hypr [
        "[silent] discord --start-minimized"
      ];
    };

    programs.vesktop.enable = true;

    # home.packages = with pkgs; [
    # (discord.override {
    #   withVencord = true;
    #   withOpenASAR = true;
    # })
    # ];
  };
}
