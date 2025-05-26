{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.zen-browser;
  enabled = cfg.enable;
in {
  options.deeznuts.programs.zen-browser = {
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

  config = mkIf enabled {
    home.packages = [
      inputs.zen-browser.packages."x86_64-linux".beta
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.hyprland.autostart.enable [
        "[silent] zen-beta"
      ];
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:^(zen-beta)$"
        "workspace ${toString (cfg.hyprland.workspace + 1)}, title:^(Picture-in-Picture)$"
      ];
    };

    xdg.mimeApps.defaultApplications = {
      # Web / browser-related
      "x-scheme-handler/http" = ["zen-beta.desktop"];
      "x-scheme-handler/https" = ["zen-beta.desktop"];
      "x-scheme-handler/about" = ["zen-beta.desktop"];
      "x-scheme-handler/unknown" = ["zen-beta.desktop"];
      "text/html" = ["zen-beta.desktop"];
      "application/xhtml+xml" = ["zen-beta.desktop"];
    };
  };
}
