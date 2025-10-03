{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.wayland.windowManager.hyprland.enable {
    home.file.".config/satty/config.toml".source = ./satty-config.toml;
    wayland.windowManager.hyprland.settings.bind = let
      base_cmd = "${pkgs.hyprshot}/bin/hyprshot --silent --clipboard-only --raw";
      satty_cmd = "${pkgs.satty}/bin/satty -f - --config ${config.home.homeDirectory}/.config/satty/config.toml";
    in [
      ", Print, exec, ${base_cmd} -m output | ${satty_cmd}"
      "ALT, Print, exec, ${base_cmd} -m window | ${satty_cmd}"
      "SUPER SHIFT, S, exec, ${base_cmd} -m region | ${satty_cmd}"
    ];
  };
}
