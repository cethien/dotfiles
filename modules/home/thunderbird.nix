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
    wayland.windowManager.hyprland = {
      settings.exec-once = mkIf cfg.autostart [
        "[silent] thunderbird"
      ];

      modals."thunderbird" = {
        binds = [
          ", XF86Mail"
          "SUPER ALT, F12"
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
