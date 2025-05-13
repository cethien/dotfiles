{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.wezterm;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs.wezterm = {
    enable = mkEnableOption "wezterm terminal";
  };

  config = mkIf enabled {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        return {
           hide_tab_bar_if_only_one_tab = true;
        }
      '';
    };

    wayland.windowManager.hyprland.settings = {
      "$terminal" = "wezterm";
      bind = [
        "SUPER, Q, exec, $terminal"
      ];
    };
  };
}
