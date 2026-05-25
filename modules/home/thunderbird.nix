{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.thunderbird;
in {
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.modals."thunderbird" = {
      binds = [", XF86Mail"];
      terminal = false;
      exec = "thunderbird";
    };

    programs.thunderbird = {
      languagePacks = ["en-US" "en-GB" "de"];
    };
  };
}
