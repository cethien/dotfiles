{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.thunderbird;
in {
  options.programs.thunderbird.autostart = lib.mkEnableOption "hyprland autostart";

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = let
      inherit (config.lib.deeznuts.hyprland) mkAutostart;
    in {
      settings.on = mkIf cfg.autostart [(mkAutostart "thunderbird" {})];

      modals."thunderbird" = {
        binds = [
          "SUPER + SHIFT + F12"
          "SHIFT + XF86Mail"
        ];
        exec = "thunderbird";
        terminal = false;
      };
    };

    services.mako.settings."app-name=Thunderbird" = {
      default-timeout = 0;
      border-color = "#0a84ae";
    };

    programs.thunderbird = {
      languagePacks = ["en-US" "en-GB" "de"];
    };
  };
}
