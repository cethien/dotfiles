{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.ghostty;
  enable = cfg.enable;
in
{
  options.deeznuts.programs.ghostty = {
    enable = mkEnableOption "ghostty terminal";
  };

  config = mkIf enable {
    programs.ghostty = {
      enable = true;
    };

    wayland.windowManager.hyprland.settings = {
      "$terminal" = "ghostty";
      bind = [
        "SUPER, Q, exec, $terminal"
      ];
    };
  };
}
