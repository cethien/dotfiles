{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  enabled = config.deeznuts.desktop.hyprland.enable;
in {
  config = mkIf config.wayland.windowManager.hyprland.enable {
    home.file.".config/satty/config.toml".source = ./satty/config.toml;

    wayland.windowManager.hyprland.settings = {
      bind = let
        hyprshot_base_cmd = "${pkgs.hyprshot}/bin/hyprshot --freeze --clipboard-only --raw";
        satty_cmd = "${pkgs.satty}/bin/satty --filename - --config ${config.home.homeDirectory}/.config/satty/config.toml";
      in [
        ", Print, exec, ${hyprshot_base_cmd} -m output | ${satty_cmd}"
        "ALT, Print, exec, ${hyprshot_base_cmd} -m window | ${satty_cmd}"
        "SUPER SHIFT, S, exec, ${hyprshot_base_cmd} -m region | ${satty_cmd}"
      ];
    };
  };
}
