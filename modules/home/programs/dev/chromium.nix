{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.chromium;
in
{
  options.deeznuts.programs.chromium = {
    enable = mkEnableOption "Chromium browser (for development)";
    hyprland.workspace = mkOption {
      type = types.int;
      default = config.deeznuts.programs.hyprland.defaultWorkspaces.development;
      description = "default hyprland workspace";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:Chromium-browser"
      ];
    };

    programs.chromium.enable = true;
  };
}
