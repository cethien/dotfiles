{
  lib,
  config,
  zen-browser,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.browser.zen-browser;
in {
  options.deeznuts.programs.browser.zen-browser = {
    enable = mkEnableOption "zen browser";
    hyprland = {
      workspace = mkOption {
        type = types.int;
        default = config.deeznuts.programs.hyprland.defaultWorkspaces.browser;
        description = "default workspace";
      };
      autostart.enable = mkEnableOption "autostart";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      zen-browser.packages."x86_64-linux".beta
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.hyprland.autostart.enable [
        "[silent] zen-beta"
      ];
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:^(zen-beta)$"
      ];
    };
  };
}
