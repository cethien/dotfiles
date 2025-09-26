{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf elem;
  cfg = config.programs.discord;
  hypr = elem "discord" config.wayland.windowManager.hyprland.autostart;
in {
  options.programs.discord = {
    enable = mkEnableOption "discord";
  };

  config = mkIf cfg.enable {
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
