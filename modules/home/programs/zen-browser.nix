{ lib, config, inputs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.zen-browser;
  cfgHyprland = config.deeznuts.programs.hyprland.programs.zen-browser;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs = {
    zen-browser.enable = mkEnableOption "zen browser";
    hyprland.programs.zen-browser.autostart = {
      enable = mkEnableOption "autostart";
      workspace = mkOption {
        type = types.int;
        default = 1;
        description = "autostart workspace";
      };
    };
  };

  config = mkIf enabled {
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfgHyprland.autostart.enable [
        "[workspace ${toString cfgHyprland.autostart.workspace} silent] zen-beta"
      ];
    };

    home.packages = [
      inputs.zen-browser.packages."x86_64-linux".beta
    ];

    xdg.mimeApps.defaultApplications = {
      # Web / browser-related
      "x-scheme-handler/http" = [ "zen-beta.desktop" ];
      "x-scheme-handler/https" = [ "zen-beta.desktop" ];
      "x-scheme-handler/about" = [ "zen-beta.desktop" ];
      "x-scheme-handler/unknown" = [ "zen-beta.desktop" ];
      "text/html" = [ "zen-beta.desktop" ];
      "application/xhtml+xml" = [ "zen-beta.desktop" ];
    };
  };
}
